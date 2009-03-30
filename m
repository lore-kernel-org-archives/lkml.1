Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZC3PCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZC3PCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZC3PCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:02:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36870 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZC3PCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:02:20 -0400
Message-ID: <49D0DDFE.5080701@redhat.com>
Date: Mon, 30 Mar 2009 10:58:06 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	<49CD7B10.7010601@garzik.org>	<49CD891A.7030103@rtr.ca>	<49CD9047.4060500@garzik.org>	<49CE2633.2000903@s5r6.in-berlin.de>	<49CE3186.8090903@garzik.org>	<49CE35AE.1080702@s5r6.in-berlin.de>	<49CE3F74.6090103@rtr.ca>	<20090329231451.GR26138@disturbed>	<20090330003948.GA13356@mit.edu>	<49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca> <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca>
In-Reply-To: <49D0DAD3.6030507@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Ric Wheeler wrote:
>> Mark Lord wrote:
>>> Ric Wheeler wrote:
> ..
>>> The kernel can crash, and the drives, in practice, will still
>>> flush their caches to media by themselves.  Within a second or two.
>>
>> Even with desktops, I am not positive that the drive write cache 
>> survives a kernel crash without data loss. If I remember correctly, 
>> Chris's tests used crashes (not power outages) to display the data 
>> corruption that happened without barriers being enabled properly.
> ..
> 
> Linux f/s barriers != drive write caches.
> 
> Drive write caches are an almost total non-issue for desktop users,
> except on the (very rare) event of a total, sudden power failure
> during extended write outs.
> 
> Very rare.  Yes, a huge problem for server farms.  No question.
> But the majority of Linux systems are probably (still) desktops/notebooks.
> 
> Cheers

I am confused as to why you think that barriers (flush barriers specifically) 
are not equivalent to drive write cache. We disable barriers when the write 
cache is off, use them only to insure that our ordering for fs transactions 
survives any power loss. No one should be enabling barriers on linux file 
systems if your write cache is disabled or if you have a battery backed write 
cache (say on an enterprise class disk array).

Chris' test of barriers (with write cache enabled) did show for desktop class 
boxes that you would get file system corruption (i.e., need to fsck the disk) a 
huge percentage of the time.

Sudden power failures are not rare for desktops in my personal experience, I see 
them several times a year in New England both at home (ice, tree limbs, etc) or 
at work (unplanned outages for repair, broken AC, etc).

Ric

