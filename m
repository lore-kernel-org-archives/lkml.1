Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbXFQSXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbXFQSXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXFQSW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:22:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:28921 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755936AbXFQSW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:22:57 -0400
Date: Sun, 17 Jun 2007 20:22:54 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: 2.6.22-rc5 regression
Message-ID: <20070617182254.GA17595@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I cheered too soon ... I just tested 2.6.22-rc5 and it hangs
again at the same point, right after printing:

agpgart: Detected an Intel 965G Chipset.

So far I tested:

188e1f81ba31af1b65a2f3611df4c670b092bbac        BAD     2007-06-17 04:09:12     v2.6.22-rc5
99f9f3d49cbc7d944476f6fde53a77ec789ab2aa        GOOD    2007-06-12 00:46:08     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
3334500b460a5eede2e3466ca97a90fe3b91ceb5        GOOD    2007-06-11 20:39:05     Merge master.kernel.org:/pub/scm/linux/kernel/git/davej/agpgart
df80b148869291621ddf51eb8716658d5bfba811        GOOD    2007-05-31 05:51:21     [AGPGART] intel_agp: add support for 945GME
9614ece14f23f2ce54a076c471aec9c91e51e79c        GOOD    2007-05-30 03:45:58     [AGPGART] intel_agp: use table for device probe
c4ca881796b7e14120851ddf6e04845ef94a314a        BAD     2007-05-30 03:40:46     [AGPGART] intel_agp: cleanup intel private data
e141d999b682cda9907179e3b843acb64c34a1d8        BAD     2007-06-10 07:26:20
b44c0267b7571b449e05f390349c4e4d080f0f4c        BAD     2007-06-11 20:32:28     Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb
bb3d2dd72302ea3eefcc6738cdd39ed5864b62f8        BAD     2007-06-11 20:31:43     Merge master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6
1a539a87280b3032fd12bc93a4a82f1d8aa97ca8        BAD     2007-06-08 22:46:58
5ecd3100e695228ac5e0ce0e325e252c0f11806f        BAD     2007-06-05 02:57:25     v2.6.22-rc4
c420bc9f09a0926b708c3edb27eacba434a4f4ba        BAD     2007-05-26 04:55:14     v2.6.22-rc3
55b637c6a003a8c4850b41a2c2fd6942d8a7f530        BAD     2007-05-19 06:06:17     v2.6.22-rc2
...                                             ...
                                                BAD                             v2.6.19-rc1
                                                GOOD                            v2.6.18

I am now doing a bisect between 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
and 188e1f81ba31af1b65a2f3611df4c670b092bbac.

The hardware that I'm using is:

An ASUS P5B Deluxe motherboard with an Intel Core 2 Quad QX6700 2.66 GHz,
4 GB of low latency DIMMs (two times KHX6400D2LLK2/2GN - two DIMM's each, 4 DIMM's
in total, which are CL4-4-4). Asus EN8600 GTS 256MB.

-- 
Carlo Wood <carlo@alinoe.com>
