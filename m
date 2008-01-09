Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYAIR2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYAIR2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYAIR1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:27:51 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:33446 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbYAIR1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:27:50 -0500
Date: Wed, 9 Jan 2008 17:27:35 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
In-Reply-To: <477AB433.5070506@zytor.com>
Message-ID: <Pine.LNX.4.64N.0801091718230.890@blysk.ds.pg.gda.pl>
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz>
 <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu>
 <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com>
 <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com>
 <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu>
 <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com>
 <4765EE7F.80002@zytor.com> <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com>
 <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu>
 <477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu>
 <477AAD7B.5040405@zytor.com> <477AB204.3070904@keyaccess.nl>
 <477AB433.5070506@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008, H. Peter Anvin wrote:

> It's specifically a side effect *we don't care about*, except in the
> by-now-somewhat-exotic case of 386+387 (where we indeed can't use it once user
> code has touched the FPU -- but we can fall back to 0x80 on those, a very
> small number of systems.)  486+ doesn't use this interface under Linux, since
> Linux uses the proper exception path on those processors.  If Compaq had wired
> up the proper signals on the first 386 PC motherboards, we wouldn't have cared
> about it on the 386 either.

 It was actually IBM who broke it with the 80286-based PC/AT because of 
the BIOS compatibility -- the vector #0x10 had already been claimed by the 
original PC for the video software interrupt call (apparently against 
Intel's recommendation not to use low 32 interrupt vectors for such 
purposes), so it could not have been reused as is for FP exception 
handling without breaking existing software.  I suppose a more complicated 
piece of glue logic could have been used along the lines of what 
eventually went into the i486, but presumably the relatively low level of 
integration of the PC/AT made such additional circuits hard to justify 
even if it indeed was considered.

  Maciej
