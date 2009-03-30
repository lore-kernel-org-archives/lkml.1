Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbZC3D4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbZC3D4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 23:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZC3D4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 23:56:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:11811 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbZC3D4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 23:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jCd0V9av0eCY5x86K47J3H/hf+kydMQsIMVZkagprVDPqMBc55Do6FsqWtVIxujji2
         3/gxaAVzqaHbNAtFsi0gTO9DrX8XnCF7O/t4vUb6J11dTPCNps9CphQJcPyBIzsOoc7a
         KvMtOOB2CiGNO3Z9J7FGtxGnfwbeMtsPcFO+A=
MIME-Version: 1.0
In-Reply-To: <20090330032827.GD13356@mit.edu>
References: <49CD7B10.7010601@garzik.org> <49CD9047.4060500@garzik.org>
	 <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org>
	 <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca>
	 <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu>
	 <9b1675090903291829u7a69df36m65b6698290773859@mail.gmail.com>
	 <20090330032827.GD13356@mit.edu>
Date: Sun, 29 Mar 2009 21:55:59 -0600
Message-ID: <9b1675090903292055q6f0f5126we47d853b96a385f6@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Trenton Adams <trenton.d.adams@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 9:28 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Sun, Mar 29, 2009 at 07:29:09PM -0600, Trenton Adams wrote:
>> I am slightly confused by the "data=ordered" thing that everyone is
>> mentioning of late.  In theory, it made sense to me before I tried it.
>>  I switched to mounting my ext3 as ext4, and I'm still seeing
>> seriously delayed fsyncs.  Theodore, I used a modified version of your
>> fsync-tester.c to bench 1M writes, while doing a dd, and I'm still
>> getting *almost* as bad of "fsync" performance as I was on ext3.  On
>> ext3, the fsync would usually not finish until the dd was complete.
>
> How much memory do you have?  On my 4gig X61 laptop, using a 5400 rpm
> laptop drive, I see typical times of 1 to 1.5 seconds, with a few
> outliers at 4-5 seconds.  With ext3, the fsync times immediately
> jumped up to 6-8 seconds, with the outliers in the 13-15 second range.

2G, and I believe 5400rpm

>
> (This is with a filesystem formated as ext3, and mounted as either
> ext3 or ext4; if the filesystem is formatted using "mke2fs -t ext4",
> what you see is a very smooth 1.2-1.5 seconds fsync latency, indirect
> blocks for very big files end up being quite inefficient.)

Oh.  I thought I had read somewhere that mounting ext4 over ext3 would
solve the problem.  Not sure where I read that now.  Sorry for wasting
your time.

>
> So I'm seeing a definite difference --- but also please remember that
> "dd if=/dev/zero of=bigzero.img" really is an unfair, worst-case
> scenario, since you are dirtying memory as fast as your CPU will dirty
> pages.  Normally, even if you are running distcc, the rate at which
> you can dirty pages will be throttled at your local network speed.

Yes, I realize that.  When trying to find performance problems I try
to be as *unfair* as possible. :D

Thanks Ted.
