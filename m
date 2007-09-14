Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbXINS3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbXINS3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXINS31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:29:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46428 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbXINS30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:29:26 -0400
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       Manu Abraham <abraham.manu@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>, mschimek@gmx.at
In-Reply-To: <d9def9db0709141046h3b2dee40l398f5ed1bbc19322@mail.gmail.com>
References: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <1189791161.2363.8.camel@gaivota>
	 <d9def9db0709141046h3b2dee40l398f5ed1bbc19322@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 15:29:11 -0300
Message-Id: <1189794551.2363.36.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > - The hybrid tuner support, that where your requirement, when all those
> > discussions started, were already added to the subsystem. So now, an
> > hybrid tuner can be accessed by both DVB and V4L devices;
> >
> 
> It's far more complex as the thing which is implemented there.
> The only thing that has been implemented is that one moduleformat
> can be loaded by the v4l and by the dvb framework nothing else at the
> moment. I told you at the kernel summit about that and I think you
> knew about that before.
> 
> Just to quote some text:
> "Right now, a separate instance of the driver is used for analog /
> digital tuning.  In order to use a single instance, we will have to
> store a pointer to the dvb_frontend structure on the bridge level, but
> there are various other prerequisites that must be dealt with before we
> get to that point.
> 
> We _will_ get there though, eventually."

Maybe it is still not perfect. Feel free to improve it. Several people
from the community, including me, already offered you help to add your
driver, reworking on the 5% of the stuff that aren't compatible with the
V4L/DVB core API design.

> > - Audio standard selection is already possible via S_STD (it is already
> > working for a few standards, like NTSC/M JP and NTSC/M KR). Maybe more
> > standards should be needed, but hey, we still have 34 bits available at
> > std mask.
> >
> 
> Let me quote some text where you've been in CC and which didn't get
> far enough to get a solution implemented.
> 
> (Michael Schimek)
> 
> "> xc3028_BG_PAL_A2_A.i2c FW_78 > B/G PAL A2
> >   Group delay: See RecITU-R BT.470-6 p.21 Response "A"
> > xc3028_BG_PAL_A2_A_MTS.i2c FW_78_MTS B/G PAL A2 ZWEITON
> > xc3028_BG_PAL_A2_B.i2c FW_78 B/G PAL A2
> >   Group delay: See RecITU-R BT.470-6 p.21 Response "B"
> > xc3028_BG_PAL_A2_B_MTS.i2c FW_78_MTS B/G PAL A2 ZWEITON
> 
> > xc3028_BG_PAL_NICAM_A.i2c FW_78 B/G PAL NICAM
> >   Group delay: See RecITU-R BT.470-6 p.21 Response "A"
> > xc3028_BG_PAL_NICAM_A_MTS.i2c FW_78_MTS B/G PAL FM
> > xc3028_BG_PAL_NICAM_B.i2c FW_78 B/G PAL NICAM
> >   Group delay: See RecITU-R BT.470-6 p.21 Response "B"
> > xc3028_BG_PAL_NICAM_B_MTS.i2c FW_78_MTS B/G PAL FM
> 
> We cannot add new standards for each of these files because only six
> bits are unassigned in the lower half of v4l2_std_id. It seems
> unecessary too, please correct me if I'm wrong.
We can use the full 64 bits of v4l2_std_id. We just need to take some
care. 

Due to the lack of __ucmpdi2 on ppc32 architecture, with some gcc
versions, a hack were added at v4l2-common.c, that truncates it to 32
bits, at the function v4l2_norm_to_name():

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commit;h=412297d31d439ba56cd4faeb3a49a6f569f40702

So, using more than 32 bits is possible, providing that we change the
implementation of v4l2_norm_to_name() or find a way for it to work with
ppc32.

Instead of just adding a standard for each possible combination, we may
just add bits for the supported audio formats. For example, we can use
the bitmask as:

#define V4L2_STD_AUDIO_NICAM_A  ((v4l2_std_id)0x04000000)
#define V4L2_STD_AUDIO_A2_A     ((v4l2_std_id)0x08000000)

Since for all other chipsets but xc3028, all audio standards are
supported, maybe we can, instead, use a negate bitmap logic for the
non-supported audio standards. Something like:

#define V4L2_STD_AUDIO_NOT_NICAM_A  ((v4l2_std_id)0x04000000)
#define V4L2_STD_AUDIO_NOT_A2_A     ((v4l2_std_id)0x08000000)

And define some macros for the specific standards you need. For example:

#define V4L2_STD_AUDIO_NOT_ALL	V4L2_STD_AUDIO_NOT_A2_A | V4L2_STD_AUDIO_NOT_NICAM_A

#define V4L2_STD_PAL_BG_A2 	V4L2_STD_PAL_BG | (V4L2_STD_AUDIO_NOT_ALL & !V4L2_STD_AUDIO_NOT_A2_A)

This way, V4L2_STD_PAL_BG will mean that this PAL/BG accepts all
possible audio standards (being binary compatible), while
V4L2_STD_PAL_BG_A2_A will mean that only A2 response 'A' audio format is
supported for PAL/BG.

-- 
Cheers,
Mauro

