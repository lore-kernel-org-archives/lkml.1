Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbYAISTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbYAISTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYAISTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:19:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYAISTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:19:36 -0500
Message-ID: <47850FEE.5000205@zytor.com>
Date: Wed, 09 Jan 2008 10:18:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com> <4765EE7F.80002@zytor.com> <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu> <477AAD7B.5040405@zytor.com> <477AB204.3070904@keyaccess.nl> <477AB433.5070506@zytor.com> <Pine.LNX.4.64N.0801091718230.890@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0801091718230.890@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Tue, 1 Jan 2008, H. Peter Anvin wrote:
> 
>> It's specifically a side effect *we don't care about*, except in the
>> by-now-somewhat-exotic case of 386+387 (where we indeed can't use it once user
>> code has touched the FPU -- but we can fall back to 0x80 on those, a very
>> small number of systems.)  486+ doesn't use this interface under Linux, since
>> Linux uses the proper exception path on those processors.  If Compaq had wired
>> up the proper signals on the first 386 PC motherboards, we wouldn't have cared
>> about it on the 386 either.
> 
>  It was actually IBM who broke it with the 80286-based PC/AT because of 
> the BIOS compatibility -- the vector #0x10 had already been claimed by the 
> original PC for the video software interrupt call (apparently against 
> Intel's recommendation not to use low 32 interrupt vectors for such 
> purposes), so it could not have been reused as is for FP exception 
> handling without breaking existing software.  I suppose a more complicated 
> piece of glue logic could have been used along the lines of what 
> eventually went into the i486, but presumably the relatively low level of 
> integration of the PC/AT made such additional circuits hard to justify 
> even if it indeed was considered.
> 

Supposedly the reason was that the DOS-less "cassette BASIC" delivered 
by Microsoft used all the INT instructions except the reserved ones as a 
weird bytecode interpreter.  Bill Gates was fond of that kind of hacks.

	-hpa
