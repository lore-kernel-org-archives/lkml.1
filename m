Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZG1ODL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZG1ODL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZG1ODJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:03:09 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57483 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZG1ODJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:03:09 -0400
Date: Tue, 28 Jul 2009 16:03:08 +0200
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Dynamic configure max_cstate
Message-ID: <20090728140308.GA17543@rhlx01.hs-esslingen.de>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de> <1248748935.2560.669.camel@ymzhang> <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com> <1248771635.2560.682.camel@ymzhang> <20090728101135.GA22358@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728101135.GA22358@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 12:11:35PM +0200, Andreas Mohr wrote:
> As a very quick test, I tried a
> while :; do :; done
> loop in shell and renicing shell to 19 (to keep my CPU out of ACPI idle),
> but bonnie -s 100 results initially looked promising yet turned out to
> be inconsistent. The real way to test this would be idle=poll.
> My test system was Athlon XP with /proc/acpi/processor/CPU0/power
> latencies of 000 and 100 (the maximum allowed value, BTW) for C1/C2.

OK, I just tested it properly.
Rebooted, did 5 bonnie -s 100 with ACPI idle, rebooted and did another 5
bonnie -s 100 with idle=poll, results:


$ cat bonnie_ACPI_* /tmp/line bonnie_poll_*
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 20084 95.3 19037  9.5 12286  4.7 18074 99.6 581752 96.6 28792.3 93.6
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 19235 93.5 24591 11.8 13916  4.3 17934 99.8 604429 100.3 27993.8 98.0
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 17221 86.3 30591 16.1 15404  5.4 18689 99.3 593296 92.7 28146.0 98.5
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 20254 99.3 110095 55.9 15722  6.1 17901 99.5 601185 99.8 28675.5 100.4
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 18274 88.5 106909 53.2 10614  4.1 18759 99.7 598833 99.4 28461.6 92.5
========
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 15274 98.2 20206  9.7 17286  7.3 18055 99.4 608112 101.0 28424.0 99.5
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 20545 99.1 25332 12.6 16392  6.1 17957 99.4 606706 100.7 27906.8 90.7
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 20482 99.2 30907 13.6 17585  6.2 17867 99.1 608090 101.0 27919.1 97.7
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 20863 99.4 138383 66.2 18945  7.6 17938 99.5 581421 96.5 27094.6 94.8
              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
       1* 100 20821 98.8 156821 70.4 11536  4.4 18747 99.0 603556 100.2 27677.8 96.9


And these values (cumulative) result in:

         ACPI		poll
Per Char 95068		97985		+3.06%
Block   291223		371649		+27.62%
Rewrite	67942		81744		+20.31%
Per Char 91357		90564		-0.87%
Block  2979495		3007885		+0.95%
RndSeek	142069.2	139022.3	-2.1%
				average: +8.16%

Now the question is how much is due to idle state entry/exit latency
and how much is due to ACPI idle/wakeup code path execution.

Still, an average of +8.16% during 5 test runs each should be quite some incentive,
and once there's a proper "idle latency skipping during expected I/O replies"
even with idle/wakeup code path reinstated we should hopefully be able to keep
some 5% improvement in disk access.

Andreas Mohr
