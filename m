Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbYJSAAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbYJSAAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 20:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYJRX7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 19:59:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbYJRX7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 19:59:51 -0400
Date: Sat, 18 Oct 2008 16:59:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Parag Warudkar" <parag.lkml@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       htejun@gmail.com, gregkh@suse.de
Subject: Re: [PATCH] x86: sysfs - kill owner field from attribute
Message-Id: <20081018165939.7b557c2b.akpm@linux-foundation.org>
In-Reply-To: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
References: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 19:11:02 -0400 "Parag Warudkar" <parag.lkml@gmail.com> wrote:

> Tejun's commit 7b595756ec1f49e0049a9e01a1298d53a7faaa15 made sysfs
> attribute->owner unnecessary.
> But the field was left in the structure to ease the merge. It's been
> over a year since that change and it is now time to start killing
> attribute->owner along with its users - one arch at a time!
> 
> This patch is attempt #1 to get rid of attribute->owner only for
> CONFIG_X86_64 or CONFIG_X86_32 .
> We will deal with other arches later on as and when possible - avr32
> will be the next since that is something I can test.
> Compile (make allyesconfig / make allmodconfig / custom config) and boot tested.
> 
> I would prefer to have this in -mm or one of the other trees for some
> time before hitting mainline just to make sure there are no issues.
> 

I'm about to send this in to Linus.

> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -21,12 +21,15 @@ struct kobject;
>  struct module;
> 
>  /* FIXME
> - * The *owner field is no longer used, but leave around
> - * until the tree gets cleaned up fully.
> + * The *owner field is no longer used.
> + * x86 tree has been cleaned up. The owner
> + * attribute is still left for other arches.
>   */
>  struct attribute {
>  	const char		*name;
> +#if !defined(CONFIG_X86_64) && !defined(CONFIG_X86_32)
>  	struct module		*owner;
> +#endif
>  	mode_t			mode;
>  };

But this part was dropped.  I did this a while ago because people kept
on adding new code to linux-next which referenced module.owner and my
tree kept on breaking.

A good time to finish this off would be immediately after 2.6.28-rc1 is
released.  Please do another pass over the whole tree and send a single
patch which fixes up those recently-introdced usages of module.owner
and which also adds the above #ifndef.

Thanks.
