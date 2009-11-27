Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZK0KKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZK0KKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 05:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbZK0KKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 05:10:22 -0500
Received: from smtp.nokia.com ([192.100.105.134]:42267 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZK0KKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 05:10:21 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: workqueues tree build failure
Date: Fri, 27 Nov 2009 12:09:18 +0200
User-Agent: KMail/1.12.3 (Linux/2.6.31-gentoo-r4; KDE/4.3.3; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>, Andy Walls <awalls@radix.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au> <s5h3a40pdm7.wl%tiwai@suse.de> <4B0F90F3.2010204@kernel.org>
In-Reply-To: <4B0F90F3.2010204@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911271209.18979.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 27 Nov 2009 10:09:23.0595 (UTC) FILETIME=[B19295B0:01CA6F49]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday 27 November 2009 10:42:27 ext Tejun Heo wrote:
> Hello,
> 
> 11/27/2009 05:37 PM, Takashi Iwai wrote:
> >> Sounds like it should be using bottom half tasklet not workqueue.
> >> Tasklet is exactly designed to handle situations like this.  Is there
> >> any reason tasklet can't be used?
> >
> > Right now the h/w accessing code is using mutex.  I'm not sure whether
> > the deeper part might sleep, though...
> 
> Ah... I see.  Using mutex from a handler where response time is
> critical is strange tho.  Anyways, I don't really think singlethread
> will satisfy the timing requirement under loaded conditions.  IMHO,
> update locking and using tasklets would be the best.

Hmmm, yes, I'm aware that it might be not sufficient to use the singlethread wq, 
but that was the fastest fix that I could think of, and it was needed for the 
linux-next.
In case of the tlv320dac33 driver, I can also play with the codec as well to 
adjust the required latency, but if I hit the wall, than for sure I will look 
for another solution for the problem.
So far this is working for my development needs, but time will tell if I need to 
make bigger modifications.

For the record: on OMAP platforms the I2C implementation is sleeping during the 
transfer (internally using interrupt based transfer), which might be not that 
wise in the tasklet. Since the I2C bus is kind of a slow bus, this could take 
several ms in some cases.

Thank you,
Péter
