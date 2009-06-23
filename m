Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZFWHYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZFWHYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZFWHYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:24:40 -0400
Received: from stz-softwaretechnik.de ([217.160.223.211]:3846 "EHLO
	stlx01.stz-softwaretechnik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbZFWHYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:24:39 -0400
Date: Tue, 23 Jun 2009 09:24:18 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com
Subject: Re: io-scheduler tuning for better read/write ratio
Message-ID: <20090623072418.GE12483@p15145560.pureserver.info>
References: <20090616154342.GA7043@p15145560.pureserver.info> <4A37CB2A.6010209@davidnewall.com> <20090616184027.GB7043@p15145560.pureserver.info> <4A37E7DB.7030100@redhat.com> <20090616185600.GC7043@p15145560.pureserver.info> <x49d494c4u0.fsf@segfault.boston.devel.redhat.com> <x49fxdsl46y.fsf@segfault.boston.devel.redhat.com> <20090622163113.GD12483@p15145560.pureserver.info> <x49hby8jbrd.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49hby8jbrd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer schrieb:
> Ralf Gross <rg@STZ-Softwaretechnik.com> writes:
> 
> > Jeff Moyer schrieb:
> >> Jeff Moyer <jmoyer@redhat.com> writes:
> >> 
> >> > Ralf Gross <rg@stz-softwaretechnik.com> writes:
> >> >
> >> >> Casey Dahlin schrieb:
> >> >>> On 06/16/2009 02:40 PM, Ralf Gross wrote:
> >> >>> > David Newall schrieb:
> >> >>> >> Ralf Gross wrote:
> >> >>> >>> write throughput is much higher than the read throughput (40 MB/s
> >> >>> >>> read, 90 MB/s write).
> >> >>> > 
> >> >>> > Hm, but I get higher read throughput (160-200 MB/s) if I don't write
> >> >>> > to the device at the same time.
> >> >>> > 
> >> >>> > Ralf
> >> >>> 
> >> >>> How specifically are you testing? It could depend a lot on the
> >> >>> particular access patterns you're using to test.
> >> >>
> >> >> I did the basic tests with tiobench. The real test is a test backup
> >> >> (bacula) with 2 jobs that create 2 30 GB spool files on that device.
> >> >> The jobs partially write to the device in parallel. Depending which
> >> >> spool file reaches the 30 GB first, one starts reading from that file
> >> >> and writing to tape, while to other is still spooling.
> >> >
> >> > We are missing a lot of details, here.  I guess the first thing I'd try
> >> > would be bumping up the max_readahead_kb parameter, since I'm guessing
> >> > that your backup application isn't driving very deep queue depths.  If
> >> > that doesn't work, then please provide exact invocations of tiobench
> >> > that reprduce the problem or some blktrace output for your real test.
> >> 
> >> Any news, Ralf?
> >
> > sorry for the delay. atm there are large backups running and using the
> > raid device for spooling. So I can't do any tests.
> >
> > Re. read ahead: I tested different settings from 8Kb to 65Kb, this
> > didn't help.
> >
> > I'll do some more tests when the backups are done (3-4 more days).
> 
> The default is 128KB, I believe, so it's strange that you would test
> smaller values.  ;)  I would try something along the lines of 1 or 2 MB.

Err, yes this should have been MB not KB.


$cat /sys/block/sdc/queue/read_ahead_kb 
16384
$cat /sys/block/sdd/queue/read_ahead_kb 
16384

I also tried different values for max_sectors_kb, nr_requests. But the
trend that writes were much faster than reads while there was read and
write load on the device didn't change.

Changing the deadline parameter writes_starved, write_expire,
read_expire, front_merges or fifo_batch didn't change this behavoir.

Ralf
