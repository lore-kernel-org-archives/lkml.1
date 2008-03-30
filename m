Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbYC3MAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbYC3MAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 08:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYC3MAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 08:00:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYC3MAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 08:00:21 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.3: regular sata drive resets - worrisome?
Date: Sun, 30 Mar 2008 13:00:09 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Roger Heflin <rogerheflin@gmail.com>
References: <200803201518.32109.hpj@urpla.net> <200803300114.40096.hpj@urpla.net> <47EEE4BF.5080609@gmail.com>
In-Reply-To: <47EEE4BF.5080609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803301400.10766.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+4WN+v7JdNNdbR2+pXJGu4i0lfB6KsRR6q4CF
 hkXgfo8HicmSdnAHady6vi5TgwsNtpXzbL7xjtKqsid6Gm3Vyc
 icGw9+abbCfyvXCqd+vEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 30. März 2008 schrieb Tejun Heo:
> Hello,
>
> Hans-Peter Jansen wrote:
> >>>> Should I be worried? smartd doesn't show anything suspicious on
> >>>> those.
> >>
> >> Can you please post the result of "smartctl -a /dev/sdX"?
> >
> > Here's the last smart report from two of the offending drives. As noted
> > before, I did the hardware reorganization, replaced the dog slow 3ware
> > 9500S-8 and the SiI 3124 with a single Areca 1130 and retired the
> > drives for now, but a nephew already showed interest. What do you
> > think, can I cede those drives with a clear conscience? The
> > Hardware_ECC_Recovered values are really worrisome, aren't they?
>
> Different vendors use different scales for the raw values.  The value is
> still pegged at the highest so it could be those raw values are okay or
> that the vendor just doesn't update value field accordingly.  My P120
> says 0 for the raw value and 904635 for hardware ECC recovered so there
> is some difference.  What do other non-failing drives say about those
> values?

The only non-failing drive was sdf as it was running in standby mode in this 
md raid 5 ensemble:

20080323-011337-sdc.log:195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       162956700
20080323-011337-sdc.log:196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
20080323-011337-sdc.log:197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
20080323-011337-sdc.log:198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
20080323-011337-sdc.log:199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
20080323-011338-sdd.log:195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       162520674
20080323-011338-sdd.log:196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
20080323-011338-sdd.log:197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
20080323-011338-sdd.log:198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
20080323-011338-sdd.log:199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
20080323-011338-sde.log:195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       148429049
20080323-011338-sde.log:196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
20080323-011338-sde.log:197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
20080323-011338-sde.log:198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
20080323-011338-sde.log:199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
20080323-011339-sdf.log:195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       1559
20080323-011339-sdf.log:196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
20080323-011339-sdf.log:197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
20080323-011339-sdf.log:198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
20080323-011339-sdf.log:199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0

> Hmmm... If the drive is failing FLUSHs, I would expect to see elevated
> reallocation counters and maybe some pending counts.  Aieee.. weird.

But there are no reallocations nor any pending sectors on any of them.

> >>>> It's been 4 samsung drives at all hanging on a sata sil 3124:
> >>
> >> FLUSH_EXT timing out usually indicates that the drive is having
> >> problem writing out what it has in its cache to the media.  There was
> >> one case where FLUSH_EXT timeout was caused by the driver failing to
> >> switch controller back from NCQ mode before issuing FLUSH_EXT but that
> >> was on sata_nv.  There hasn't been any similar problem on sata_sil24.
> >
> > Hmm, I didn't noticed any data distortions, and if there where, they
> > live on as copies in their new home..
>
> It should have appeared as read errors.  Maybe the drive successfully
                             ^^^^
                             write (I guess)
> wrote those sectors after 30+ secs timeout.

That would point to some driver issue, wouldn't it? Roger Heflin also
experienced similar behavior with that controller, which wasn't 
reproducible with another. 

I can offer to you rebuilding that md in a test environment, and giving 
you access to it, if you're interested.

Anyway, thanks for caring Tejun,
Pete
