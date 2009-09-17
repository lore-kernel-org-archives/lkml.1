Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbZIQFmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbZIQFmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZIQFmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:42:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbZIQFmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:42:10 -0400
Date: Wed, 16 Sep 2009 22:41:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make safe some helpers building on container_of
Message-Id: <20090916224157.cfa621c4.akpm@linux-foundation.org>
In-Reply-To: <20090914082700.8550.94087.stgit@szonett.ki.iif.hu>
References: <20090914082700.8550.94087.stgit@szonett.ki.iif.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 10:27:00 +0200 Ferenc Wagner <wferi@niif.hu> wrote:

> For example, drivers/base/core.c contains
> 
> #define to_root_device(dev) container_of(dev, struct root_device, dev)
> 
> which works fine as long as the 'to_root_device' macro is always
> applied to a variable called 'dev', as it is the case in the current
> kernel sources.  However, it breaks as soon as it gets applied to a
> variable of any other name, as the name of the variable is also
> substituted into the third argument of the 'container_of' macro, which
> really should stay 'dev' in the above case.
> 
> This patch renames the real macro arguments in all 5 such constructs
> found by git-grep -E '#define.*container_of *\( *([^ ,]+) *,.*, *\1 *\)',
> which may have missed some similar dangerous constructs, of course.
> So these changes probably cross all possible boundaries of responsibility,
> and I do not know how to best handle it, suggestions welcome.
> 
> Btw. this dangerous idom is also popularised by the excellent Linux Device
> Drivers book (3rd edition, chapter 14, bottom of page 383).
> 
> ...
>
> -#define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
> +#define EVT_TO_HPET_DEV(evtdev) container_of(evtdev, struct hpet_dev, evt)

There is no reason whatsoever for implementing these things as macros
and for the life of me I don't understand why people do this.

If we're going to fix these things then how about we turn them into
C functions thereby making them even safer?



y:/usr/src/linux-2.6.31> grep -r 'define.*container_of' . | wc -l
347

Sigh.
