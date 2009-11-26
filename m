Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbZKZISb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbZKZISb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbZKZISa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:18:30 -0500
Received: from smtp.nokia.com ([192.100.122.230]:38256 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476AbZKZIS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:18:28 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: workqueues tree build failure
Date: Thu, 26 Nov 2009 10:16:58 +0200
User-Agent: KMail/1.12.3 (Linux/2.6.31-gentoo-r4; KDE/4.3.3; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au> <4B0E3677.6000603@kernel.org>
In-Reply-To: <4B0E3677.6000603@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911261016.58810.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 26 Nov 2009 08:17:03.0089 (UTC) FILETIME=[D5813E10:01CA6E70]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday 26 November 2009 10:04:07 ext Tejun Heo wrote:
> 11/26/2009 05:00 PM, Stephen Rothwell wrote:
> > Hi Tejun,
> >
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> >
> > sound/soc/codecs/tlv320dac33.c: In function 'dac33_i2c_probe':
> > sound/soc/codecs/tlv320dac33.c:1121: error: implicit declaration of
> > function 'create_rt_workqueue' sound/soc/codecs/tlv320dac33.c:1121:
> > warning: assignment makes pointer from integer without a cast
> >
> > Caused by commit 1b2d88bf4c63ed3a8c9033c358905d3463aa8bc2 ("stop_machine:
> > reimplement without using workqueue") (which removed create_rt_workqueue
> > ()) interacting with commit c8bf93f0fe8c5a509a29e30f3bac823fa0f6d96e
> > ("ASoC: Codec driver for Texas Instruments tlv320dac33 codec") from the
> > sound tree.
> >
> > I have no idea how to fix this, so I have used the workqueues tree from
> > next-20091125 until someone can suggest a solution.
> 
> Takashi, RT workqueue is going away.  Do you really need it?

What can be used instead of RT workqueue?
The tlv320dac33 needs RT workqueue because I need to send the I2C command with 
minimum delay to the codec. If this can not be done (the workqueue is delayed), 
and the codec does not receive the command in time, it will literally die.

What are the options to replace the RT workqueue?

> 
> Thanks.
> 

-- 
Péter
