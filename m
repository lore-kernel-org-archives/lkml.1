Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYGHXmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYGHXmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYGHXl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:41:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42882 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYGHXl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:41:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>
	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>
	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>
	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>
	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>
	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com>
Date: Tue, 08 Jul 2008 16:36:49 -0700
In-Reply-To: <4873B016.8010404@sgi.com> (Mike Travis's message of "Tue, 08 Jul
	2008 11:21:10 -0700")
Message-ID: <m1r6a4c5im.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2829]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Mike Travis <travis@sgi.com> writes:

> Unfortunately it's back to the problem of faulting before x86_64_start_kernel()
> and grub just immediately reboots.  So I'm back at analyzing assembler and
> config differences.

Ok.  That is a narrow window of code.  So it shouldn't be too bad, nasty though.

If you would like to trace through it I have attached my serial port
debugging routines that I use in that part of the code.

Eric


--=-=-=
Content-Disposition: inline; filename=linux-debug.S

#if 1
/* Base Address */
#define TTYS0_BASE	0x3f8
/* Data */
#define TTYS0_RBR (TTYS0_BASE+0x00)
#define TTYS0_TBR (TTYS0_BASE+0x00)
/* Control */
#define TTYS0_IER (TTYS0_BASE+0x01)
#define TTYS0_IIR (TTYS0_BASE+0x02)
#define TTYS0_FCR (TTYS0_BASE+0x02)
#define TTYS0_LCR (TTYS0_BASE+0x03)
#define TTYS0_MCR (TTYS0_BASE+0x04)

#define TTYS0_DLL (TTYS0_BASE+0x00)
#define TTYS0_DLM (TTYS0_BASE+0x01)
/* Status */
#define TTYS0_LSR (TTYS0_BASE+0x05)
#define TTYS0_MSR (TTYS0_BASE+0x06)
#define TTYS0_SCR (TTYS0_BASE+0x07)

#define TTYS0_BAUD 9600
#define TTYS0_DIV  (115200/TTYS0_BAUD)
#define TTYS0_DIV_LO	(TTYS0_DIV&0xFF)
#define TTYS0_DIV_HI	((TTYS0_DIV >> 8)&0xFF)

#if ((115200%TTYS0_BAUD) != 0)
#error Bad ttyS0 baud rate
#endif

#define TTYS0_INIT	\
	/* disable interrupts */	\
	movb	$0x00, %al		; \
	movw	$TTYS0_IER, %dx		; \
	outb	%al, %dx		; \
					; \
	/* enable fifos */		\
	movb	$0x01, %al		; \
	movw	$TTYS0_FCR, %dx		; \
	outb	%al, %dx		; \
					; \
	/* Set Baud Rate Divisor to TTYS0_BAUD */	\
	movw	$TTYS0_LCR, %dx		; \
	movb	$0x83, %al		; \
	outb	%al, %dx		; \
					; \
	movw	$TTYS0_DLL, %dx		; \
	movb	$TTYS0_DIV_LO, %al	; \
	outb	%al, %dx		; \
					; \
	movw	$TTYS0_DLM, %dx		; \
	movb	$TTYS0_DIV_HI, %al	; \
	outb	%al, %dx		; \
					; \
	movw	$TTYS0_LCR, %dx		; \
	movb	$0x03, %al		; \
	outb	%al, %dx
	

	/* uses:	ax, dx */
#define TTYS0_TX_AL		\
	mov	%al, %ah	; \
9:	mov	$TTYS0_LSR, %dx	; \
	inb	%dx, %al	; \
	test	$0x20, %al	; \
	je	9b		; \
	mov	$TTYS0_TBR, %dx	; \
	mov	%ah, %al	; \
	outb	%al, %dx

	/* uses:	ax, dx */
#define TTYS0_TX_CHAR(byte)	\
	mov	byte, %al	; \
	TTYS0_TX_AL

	/* uses:	eax, dx */
#define TTYS0_TX_HEX32(lword)	\
	mov	lword, %eax	; \
	shr	$28, %eax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %eax	; \
	shr	$24, %eax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %eax	; \
	shr	$20, %eax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %eax	; \
	shr	$16, %eax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %eax	; \
	shr	$12, %eax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %eax	; \
	shr	$8, %eax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %eax	; \
	shr	$4, %eax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %eax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL

	/* uses:	rax, dx */
#define TTYS0_TX_HEX64(lword)	\
	mov	lword, %rax	; \
	shr	$60, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$56, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$52, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$48, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$44, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$40, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$36, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$32, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$28, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$24, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$20, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$16, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$12, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$8, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	shr	$4, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL		; \
				; \
	mov	lword, %rax	; \
	and	$0x0f, %al	; \
	add	$'0', %al	; \
	cmp	$'9', %al	; \
	jle	9f		; \
	add	$39, %al	; \
9:				; \
	TTYS0_TX_AL
	

#define DEBUG(x) TTYS0_TX_CHAR($x) ;  TTYS0_TX_CHAR($'\r') ;  TTYS0_TX_CHAR($'\n')
#define DEBUG_TX_HEX32(x) TTYS0_TX_HEX32(x); TTYS0_TX_CHAR($'\r') ;  TTYS0_TX_CHAR($'\n')
#define DEBUG_TX_HEX64(x) TTYS0_TX_HEX64(x); TTYS0_TX_CHAR($'\r') ;  TTYS0_TX_CHAR($'\n')
#endif

--=-=-=--
