Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbXFXPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbXFXPxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbXFXPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:53:00 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21797 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbXFXPw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:52:58 -0400
Message-ID: <467E9356.1030200@msgid.tls.msk.ru>
Date: Sun, 24 Jun 2007 19:52:54 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Jeff Garzik <jeff@garzik.org>, Carlo Wood <carlo@alinoe.com>,
       Tejun Heo <htejun@gmail.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org> <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org> <467E5C5E.6000706@msgid.tls.msk.ru> <20070624125957.GA28067@gallifrey> <Pine.LNX.4.64.0706241021030.12207@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706241021030.12207@p34.internal.lan>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Don't forget about max_sectors_kb either (for all drives in the SW RAID5
> array)
> 
> max_sectors_kb = 8
> $ dd if=/dev/zero of=file.out6 bs=1M count=10240
> 10737418240 bytes (11 GB) copied, 55.4848 seconds, 194 MB/s
> 
> max_sectors_kb = 128
> 10737418240 bytes (11 GB) copied, 22.6298 seconds, 474 MB/s

Well.  You're comparing something different.  Yes, this
thread is about linux software raid5 in the first place,
but I were commenting about [NT]CQ within a single drive.

Overall, yes, the larger your reads/writes to the drive
becomes, the faster its linear performance is.  Yet you
have to consider real workload instead of very synthetic
dd test.  It may be good approcsimation of a streaming
video workload (when you feed a large video file over
network or something like that), but even with this,
you probably want to feed several files at once (different
files to different clients), so single-threaded test
here isn't very useful.  IMHO anyway, and good for a
personal computer test.

/mjt
