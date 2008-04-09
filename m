Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYDIMBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYDIMBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 08:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYDIMBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 08:01:01 -0400
Received: from mail.hevs.ch ([153.109.23.10]:55134 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbYDIMBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:01:00 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [BUG, bisected] atmel_spi: hard lockups in transfer
Date: Wed, 9 Apr 2008 14:00:55 +0200
User-Agent: KMail/1.9.9
Cc: Ben Nizette <bn@niasdigital.com>, kernel <kernel@avr32linux.org>,
       slipszi@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <1207438118.3319.8.camel@moss.renham> <20080406181817.5824f962@siona.local>
In-Reply-To: <20080406181817.5824f962@siona.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804091400.56727.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008, Haavard Skinnemoen wrote:
> On Sun, 06 Apr 2008 09:28:38 +1000
> Ben Nizette <bn@niasdigital.com> wrote:
> 
> > Hi,
> > 
> > For some weeks now there have been reports flying across the main AVR32
> > support forum, avrfreaks [1], that atmel_spi now hard-hangs on most
> > transfers.  The behaviour is not apparent in .23 and is in .24+.  One
> > tester was good enough to bisect the problem and turned up
> 
> Thanks for reporting this.
> 
> > 154443c72f47169ebcb3a7befbff0e934c49bff3
> > atmel_spi: chain DMA transfers
> > 
> > as the culprit.  The tester also had to revert 
> > 
> > commit 8bacb219018a52e6f02a3cff6a7badf102ddfc44
> > atmel_spi: fix dmachain oops with DEBUG enabled
> > 
> > when they reverted 154443 as they were not confident enough to resolve
> > the conflicts that resulted from just reverting the first one.
> 
> That is indeed the correct way to resolve the conflict since the latter
> fixes a bug introduced by the former.
> 
> > The discussion thread involving this can be seen at [2].
> > 
> > As I say, this is present in .24+ so any fix will be a stable candidate
> > as well as .25 material (if we haven't missed the boat by then).
mainline .24+ is not affected (linux-2.6.24.3.atmel.3.tar.bz2 is).

> 
> I'm afraid I don't have much time to look at this right now...but I'll
> see what I can do. It's strange that I never noticed this problem
> myself -- I did see some overrun issues, but I blamed it on the
> throughput improvements and just reduced the speed slightly.
This patch seems to have problems at least on avr32, since this is only
a speed-up patch, we should revert them.

Regards

Marc

