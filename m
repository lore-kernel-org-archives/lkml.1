Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYH1PlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYH1PlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYH1PlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:41:00 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48845 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753957AbYH1Pk7 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:40:59 -0400
Date: Thu, 28 Aug 2008 17:40:51 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jared Hulbert <jaredeh@gmail.com>
cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
In-Reply-To: <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0808281737150.28552@vixen.sonytel.be>
References: <48AD00C4.6060302@gmail.com> <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
 <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-776896427-1219938051=:28552"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-776896427-1219938051=:28552
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 22 Aug 2008, Jared Hulbert wrote:
> > The version in SVN seems to be slightly older than the one you submitted?
> 
> Oops.  Okay I must have neglected to sync at the very end.  Thanks.
> 
> I forgot, there is also a git repo at
> 
> git://git.infradead.org/users/jehulber/axfs.git
> 
> > Which platform(s) do you use for testing?
> 
> ARM, x86
> 
> > I gave AxFS a try on PS3 (ppc64, always use big-endian 64-bit for testing new
> > code ;-).
> 
> Smart.  Hmmm, If only I had a PS3....

I heard you got one? ;-)

> > When mounting the image, I got the crash below:
> >
> > | attempt to access beyond end of device
> > | loop0: rw=0, want=4920, limit=4912

Interestingly, it also doesn't work on UserModeLinux (x86, 32-bit):

| attempt to access beyond end of device
| loop0: rw=0, want=24, limit=16
| 
| EIP: 0073:[<0811ec67>] CPU: 0 Not tainted ESP: 007b:19515c38 EFLAGS: 00210212
|     Not tainted
| EAX: 00000000 EBX: 00001000 ECX: 19484aa0 EDX: 190d9f0c
| ESI: 195ee000 EDI: 19515cd0 EBP: 19515c6c DS: 007b ES: 007b
| 08247af0:  [<08069ba3>] show_regs+0xb4/0xb9
| 08247b1c:  [<080591ee>] segv+0x222/0x23a
| 08247bbc:  [<08059296>] segv_handler+0x90/0x9a
| 08247c68:  [<080649b8>] sig_handler_common+0x63/0x72
| 08247ce0:  [<08064cac>] sig_handler+0x31/0x3d
| 08247cec:  [<08064c0b>] handle_signal+0x4c/0x7a
| 08247d0c:  [<08066327>] hard_handler+0xf/0x14
| 08247d1c:  [<005c0420>] 0x5c0420
| 
| Kernel panic - not syncing: Kernel mode fault at addr 0x14, ip 0x811ec67
| 
| EIP: 0073:[<4010a44e>] CPU: 0 Not tainted ESP: 007b:bfa323a0 EFLAGS: 00200246
|     Not tainted
| EAX: ffffffda EBX: 080595f8 ECX: 080595c8 EDX: 080595d8
| ESI: c0ed0000 EDI: 00000000 EBP: bfa323d8 DS: 007b ES: 007b
| 08247a5c:  [<08069ba3>] show_regs+0xb4/0xb9
| 08247a88:  [<08059462>] panic_exit+0x25/0x3b
| 08247a9c:  [<08083642>] notifier_call_chain+0x27/0x4c
| 08247ac4:  [<0808367e>] __atomic_notifier_call_chain+0x17/0x19
| 08247ad4:  [<08083695>] atomic_notifier_call_chain+0x15/0x17
| 08247af0:  [<0806fd87>] panic+0x52/0xd8
| 08247b10:  [<080591fc>] segv+0x230/0x23a
| 08247bbc:  [<08059296>] segv_handler+0x90/0x9a
| 08247c68:  [<080649b8>] sig_handler_common+0x63/0x72
| 08247ce0:  [<08064cac>] sig_handler+0x31/0x3d
| 08247cec:  [<08064c0b>] handle_signal+0x4c/0x7a
| 08247d0c:  [<08066327>] hard_handler+0xf/0x14
| 08247d1c:  [<005c0420>] 0x5c0420

Commandline is `mount image.axfs /mnt -o loop -t axfs'.

Is there something wrong with the axfs version you submitted, or with
mkfs.axfs?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-776896427-1219938051=:28552--
