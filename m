Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbXEBU7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbXEBU7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXEBU7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:59:53 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbXEBU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:59:50 -0400
Message-ID: <4638FBB8.4020506@zytor.com>
Date: Wed, 02 May 2007 13:59:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>> [...]
>> 80x50 is useful for the above reason. Yeah, it's ugly, but it's useful for 
>> the "It's too much work to try to do anything but just take a digital 
>> photo of the screen". And that 50-line mode will actually be 43 in EGA 
>> mode, I think.
>>
>> The 132x50 mode is probably a bit prettier, and is fairly common too, and 
>> useful for the same reason.
> 
> Seconded. 80x50, and where platforms support it, *80x60 and 132x60*,
> is kinda handy (despite the font getting smaller and smaller, heh),
> esp. when you don't run it in VMware and not have some capturing
> device (serial con/netconsole.. takes time to set up)
> 

This is what I've decided on doing:

I'm having a framework for multiple drivers (probe and set methods,
basically); the stock distro will have VGA and VESA drivers only.
Dropping new drivers in is trivial if someone wants to.  I was going to
leave in the CL54xx and ATI drivers since I actually have specimens of
those, except it appears that on current specimens of those cards, the
probe succeeds but the mode-setting fails, so I dropped those as well.

If someone happens to have algorithms for setting 132-character mode on
especially the CL54xx series with raw register writes I'd actually be
interested, since that's what Bochs and Qemu emulate, and on those it
would be really nice to have a larger text mode.

	-hpa
