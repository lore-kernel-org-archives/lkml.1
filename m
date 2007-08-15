Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbXHOOGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbXHOOGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbXHOOGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:06:05 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:40240 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbXHOOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:06:04 -0400
Date: Wed, 15 Aug 2007 10:04:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Glauber de Oliveira Costa <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       glommer@gmail.com
Subject: Re: [PATCH 18/25][V3] turn priviled operations into macros in entry.S
In-Reply-To: <11871823991803-git-send-email-gcosta@redhat.com>
Message-ID: <Pine.LNX.4.58.0708151002001.25252@gandalf.stny.rr.com>
References: <11871821854176-git-send-email-gcosta@redhat.com>
 <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com>
 <11871822163867-git-send-email-gcosta@redhat.com>
 <11871822244170-git-send-email-gcosta@redhat.com>
 <11871822342754-git-send-email-gcosta@redhat.com>
 <11871822421713-git-send-email-gcosta@redhat.com> <1187182253740-git-send-email-gcosta@redhat.com>
 <1187182268408-git-send-email-gcosta@redhat.com> <1187182282913-git-send-email-gcosta@redhat.com>
 <11871822951747-git-send-email-gcosta@redhat.com>
 <11871823042011-git-send-email-gcosta@redhat.com>
 <11871823151789-git-send-email-gcosta@redhat.com>
 <11871823273810-git-send-email-gcosta@redhat.com>
 <11871823373106-git-send-email-gcosta@redhat.com>
 <11871823673236-git-send-email-gcosta@redhat.com>
 <11871823782610-git-send-email-gcosta@redhat.com>
 <11871823892519-git-send-email-gcosta@redhat.com>
 <11871823991803-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--

On Wed, 15 Aug 2007, Glauber de Oliveira Costa wrote:

> @@ -566,10 +596,15 @@ retint_restore_args:
>  restore_args:
>  	RESTORE_ARGS 0,8,0
>  iret_label:
> +#ifdef CONFIG_PARAVIRT
> +	INTERRUPT_RETURN
> +#endif
> +.globl do_iretq;

Is the .globl really required here? I would think that the reference in
the fixup section would be resolved with in the compiling of this object.

-- Steve

> +do_iretq:
>  	iretq
>
>  	.section __ex_table,"a"
> -	.quad iret_label,bad_iret
> +	.quad do_iretq, bad_iret
>  	.previous
>  	.section .fixup,"ax"
>  	/* force a signal here? this matches i386 behaviour */
>
