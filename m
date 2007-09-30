Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXI3MaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXI3MaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 08:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXI3M35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 08:29:57 -0400
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:40460 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755262AbXI3M34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 08:29:56 -0400
From: Florian Schmidt <mista.tapas@gmx.net>
To: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: getting FUSD compiled with current kernels
Date: Sun, 30 Sep 2007 14:29:52 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200709291823.35868.mista.tapas@gmx.net> <75b66ecd0709291826j64c45bcdoc957411f0fb25689@mail.gmail.com>
In-Reply-To: <75b66ecd0709291826j64c45bcdoc957411f0fb25689@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301429.53101.mista.tapas@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007, Lee Revell wrote:
> On 9/29/07, Florian Schmidt <mista.tapas@gmx.net> wrote:
> > My goal is to hack up oss2jack [3] to use ALSA pcm devices.. And a later
> > goal is to create a virtual ALSA soundcard [which would multiplex access
> > to a real non hw-mixing capable soundcard] to finally end the dmix
> > software mixing woes linux users have to endure for the last years :)
>
> What problems with ALSA's userspace mixing are you trying to solve?

I think that for example the aoss approach to providing software mixing to OSS 
apps is fundamentally flawed. The LD_PRELOAD_LIBRARY mechanism does not work 
for all applications. The OSS emultion in ALSA that does work for pretty much 
all OSS apps is the kernel level OSS emulation [which directly provides the 
OSS conform device files] sitting directly on an ALSA device driver module. 
Having a virtual ALSA soundcard which would route back to userspace one could 
make the OSS emu use this device instead providing to-userspace routing of 
all OSS apps..

The same argument, though in a weaker form holds for badly coded ALSA apps 
which open soundcards "directly" via "hw:0" pcm device names. It would be 
cool, if these could be made to play nice trivially. Here again, a virtual 
ALSA device which routes back to userspace would be great..

Simply make the virtual device card 0 in the system..

Dmix wouldn't be obsoleted by this at all. I'm not sure on the details (still 
learning), but the virtual ALSA device routing the signal back to user space 
could then in turn use dmix on a real alsa device to provide the sw mixing 
(it would indeed be a very thin userspace driver as it basically directly 
uses an ALSA pcm as "slave")..

This is not thought of as a replacement for ALSA userspace libasound2.. Not at 
all. It's just a cool thing to have (tm) in many situations, solving these 
cases which drive some ALSA users (me included) nuts :)

Regards,
Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
