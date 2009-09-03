Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZICMLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZICMLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 08:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZICMLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 08:11:52 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:54654 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZICMLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 08:11:51 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz146fK1432R98dNa594izz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KPE9VI-02-JHI-02
X-M-MSG: 
Date: Thu, 3 Sep 2009 14:10:45 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH 0/8] load-balancing and cpu_power -v2
Message-ID: <20090903121045.GK7216@alberich.amd.com>
References: <20090901083431.748830771@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090901083431.748830771@chello.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Sep 2009 12:10:45.0839 (UTC) FILETIME=[910415F0:01CA2C8F]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 10:34:31AM +0200, Peter Zijlstra wrote:
> A more complete version, one that compiles and mostly works on the
> simple tests to which it was subjected.
> 
> It still lacks integration with APERF/MPERF because that stuff was
> hidding in some acpi driver instead of placed in arch code for general
> consumption.. will fix.
> 
> Also, SD_SHARE_CPUPOWER seems redundant in the face of sd->level ==
> SD_LV_SIBLING, should we remove the SD_flag or depricate the level?
> 
> Anyway, have at it, poke holes and report issues.

Tested it (to a certain extend).
Found no performance degradation (on 1P, 2P, 4P systems). (One could
think performance might slightly degrade due to more frequent
__cpu_power updates).

Issue that I see is that switching between scheduling policies has no
effect on already running tasks:

- tasks that are already distributed among sockets are _not_
  concentrated on one socket when switching from performance to
  power_savings scheduling

- tasks utilizing a socket are _not_ distributed among sockets when
  switching from power_savings to performance policy

This applies to modification of sched_mc_power_savings. And I think
one of above scenarios is already broken in tip/master w/o your
patches.

Otherwise especially wrt to integration of APERF/MPERF this seems to
be a good approach.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


