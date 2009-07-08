Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZGHKhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZGHKhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZGHKhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:37:12 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56612 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZGHKhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:37:10 -0400
Message-ID: <4A5476D2.7040709@monstr.eu>
Date: Wed, 08 Jul 2009 12:37:06 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       microblaze-uclinux@itee.uq.edu.au, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mundt <lethal@linux-sh.org>, Tony Luck <tony.luck@intel.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH percpu 1/2] microblaze: include EXIT_TEXT to _stext
References: <4A546646.70305@kernel.org>
In-Reply-To: <4A546646.70305@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> Microblaze wants to throw out EXIT_TEXT during runtime too.  This
> hasn't caused trouble till now because the linker script didn't
> discard EXIT_TEXT and it ended up in its default output section.  As
> discard definition is about to be unified, include EXIT_TEXT into
> _stext explicitly and while at it replace explicit exitcall definition
> to EXIT_CALL.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Michal, I added the commit messaeg and SOB.  If you don't like it
> please let me know.

It is ok. I rechecked it and works.

Thanks,
Michal


> 
> If there's no further objection, I'll commit this and the next patch
> to percpu#for-next.
> 
> Thanks.
> 
>  arch/microblaze/kernel/vmlinux.lds.S |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: work/arch/microblaze/kernel/vmlinux.lds.S
> ===================================================================
> --- work.orig/arch/microblaze/kernel/vmlinux.lds.S
> +++ work/arch/microblaze/kernel/vmlinux.lds.S
> @@ -23,8 +23,8 @@ SECTIONS {
>  		_stext = . ;
>  		*(.text .text.*)
>  		*(.fixup)
> -
> -		*(.exitcall.exit)
> +               EXIT_TEXT
> +               EXIT_CALL
>  		SCHED_TEXT
>  		LOCK_TEXT
>  		KPROBES_TEXT


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
