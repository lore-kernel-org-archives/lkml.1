Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbYLADLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbYLADLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 22:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYLADLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 22:11:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYLADLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 22:11:40 -0500
Date: Sun, 30 Nov 2008 19:11:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, gregkh@suse.de
Subject: Re: mmotm 2008-11-29-01-53 uploaded
Message-Id: <20081130191124.e16de170.akpm@linux-foundation.org>
In-Reply-To: <20081201111040.42b2a908.kamezawa.hiroyu@jp.fujitsu.com>
References: <200811290959.mAT9xuhC004277@imap1.linux-foundation.org>
	<20081201111040.42b2a908.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 11:10:40 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Sat, 29 Nov 2008 01:59:56 -0800
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-11-29-01-53 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.28-rc6:
> > 
> Hi, in recent changes of linux-next.patch
> 
> ==
> static void __init param_sysfs_builtin(void)
> {
>         struct kernel_param *kp;
>         unsigned int name_len;
>         char modname[MODULE_NAME_LEN];
> 
>         for (kp = __start___param; kp < __stop___param; kp++) {
>                 char *dot;
> 
>                 if (kp->perm == 0)
>                         continue;
> 
>                 dot = strchr(kp->name, '.');
>                 BUG_ON(!dot); <======================================(*)
>                 name_len = dot - kp->name + 1;
>                 strlcpy(modname, kp->name, name_len);
>                 kernel_add_sysfs_param(modname, kp, name_len);
>         }
> 
> ==
> Above (*) is added.
> 
> I hit BUG_ON() at (*). That was because usbcore was not a module and module param
> kp->name was "nousb".... not including any dot.
> (If compled as module, the kernel works well.)
> 

Thanks, that'll be

commit 9b473de87209fa86eb421b23386693b461612f30
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Oct 22 10:00:22 2008 -0500

    param: Fix duplicate module prefixes

I assume.  Rusty's been on the schnapps again ;)
