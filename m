Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbXJCMkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbXJCMkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXJCMko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:40:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46974 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbXJCMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:40:43 -0400
Date: Wed, 3 Oct 2007 21:40:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, shiwh@cn.fujitsu.com
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
Message-Id: <20071003214029.edcafcc5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200710031220.l93CK75T028343@harpo.it.uu.se>
References: <200710031220.l93CK75T028343@harpo.it.uu.se>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 14:20:07 +0200 (MEST)
Mikael Pettersson <mikpe@it.uu.se> wrote:

> What I don't agree with is the logic itself:
> - You only catch altstack overflow caused by the kernel pushing
>   a sigframe. You don't catch overflow caused by the user-space
>   signal handler pushing its own stack frame after the sigframe.
> - SUSv3 specifies the effect of altstack overflow as "undefined".
> - The overflow problem can be solved in user-space: allocate the
>   altstack with mmap(), then mprotect() the lowest page to prevent
>   accesses to it. Any overflow into it, by the kernel's signal
>   delivery code or by the user-space signal handler, will be caught.
> 
> So this patch gets a NAK from me.
> 

I can understand what you say, but a program which meets this problem
cannot be debugged ;(

gdb just shows infinit loop of function frames and origignal signal frame
which includes the most important information is overwritten.

Ah yes, user's sigaltstack setup is bad if this happens, but I can't ask
novice programmers to take care of "please verify the page next to
sigaltstack is not mapped or protected." such a thing is not written in man(2)
page of sigaltstack now.


Thanks,
-Kame
