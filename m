Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYEFICs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYEFICs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYEFICa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:02:30 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:33940 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752716AbYEFIC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:02:29 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Linux 2.6.26-rc1
Date: Tue, 6 May 2008 09:02:25 +0100
User-Agent: KMail/1.9.9
Cc: Robin Holt <holt@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org> <20080504160904.GF19717@sgi.com> <Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805060902.25835.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008 22:04:17 Mauro Carvalho Chehab wrote:
> Alistair,
>
> Sorry for not answering earlier, I got some days off (I still didn't read
> all messages from you - I'm flooded of messages here).
>
> >> I have DVB_CORE=n and VIDEO_DEV=y. VIDEO_DEV is:
> >>
> >> config VIDEO_DEV
> >>         tristate "Video For Linux"
> >>
> >> So if you enable Video For Linux, the tuner-core is automatically built,
> >> even if no tuners are selected? Surely that's wrong..
> >
> > That is probably correct.  Video For Linux is used for capturing video
> > streams.  The fact that you can get this invalid config to fail to build
> > should be reported to the v4l folks and let them fix it up.
>
> Yes, this is correct, if you select a board that supports tuner (for
> example, bttv, or cx88).
>
> The error is that most tuners are dependent of I2C. The right fix seems to
> do this:
>
>
> config MEDIA_TUNER
>          tristate
>          default (DVB_CORE || VIDEO_DEV) && I2C
>          depends on (DVB_CORE || VIDEO_DEV) && I2C

This still seems imperfect -- if I have I2C=y and VIDEO_DEV=y, but DVB_CORE=n 
(and no board types selected), it'll still build at least some of the tuner 
code into the V4L core.

This is still true even if I set MEDIA_TUNER_CUSTOMIZE=y and set all of the 
tuners to 'n'. I'd assumed that this was an artefact of the complex Kconfig 
logic here, and was not intentional.

Thanks for fixing the compile issue though, I've confirmed that it works.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
