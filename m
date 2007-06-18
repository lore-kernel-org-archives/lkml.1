Return-Path: <linux-kernel-owner+w=401wt.eu-S1764787AbXFRSDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764787AbXFRSDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761979AbXFRSD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:03:29 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:58374 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760495AbXFRSD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:03:28 -0400
Date: Mon, 18 Jun 2007 14:03:27 -0400
To: david@lang.hm
Cc: Brendan Conoboy <blc@redhat.com>, Neil Brown <neilb@suse.de>,
       Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
Message-ID: <20070618180327.GP10008@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:28:38AM -0700, david@lang.hm wrote:
> I plan to test the different configurations.
> 
> however, if I was saturating the bus with the reconstruct how can I fire 
> off a dd if=/dev/zero of=/mnt/test and get ~45M/sec whild only slowing the 
> reconstruct to ~4M/sec?
> 
> I'm putting 10x as much data through the bus at that point, it would seem 
> to proove that it's not the bus that's saturated.

dd 45MB/s from the raid sounds reasonable.

If you have 45 drives, doing a resync of raid5 or radi6 should probably
involve reading all the disks, and writing new parity data to one drive.
So if you are writing 5MB/s, then you are reading 44*5MB/s from the
other drives, which is 220MB/s.  If your resync drops to 4MB/s when
doing dd, then you have 44*4MB/s which is 176MB/s or 44MB/s less read
capacity, which surprisingly seems to match the dd speed you are
getting.  Seems like you are indeed very much saturating a bus
somewhere.  The numbers certainly agree with that theory.

What kind of setup is the drives connected to?

--
Len Sorensen
