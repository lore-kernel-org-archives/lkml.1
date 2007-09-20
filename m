Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbXITRR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbXITRR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXITRRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:17:49 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:17312 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbXITRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:17:48 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46F2A99A.3080400@am.sony.com>
Date: Thu, 20 Sep 2007 10:10:50 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Michael Opdenacker <michael@free-electrons.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>
Subject: Monster switch for small size (was Linux-tiny revival)
References: <46F1645D.9050406@am.sony.com> <20070919142805.e0242fcf.akpm@linux-foundation.org> <46F19778.7000408@am.sony.com> <46F1A4FF.6040808@free-electrons.com> <20070920091042.GA6035@shadowen.org>
In-Reply-To: <20070920091042.GA6035@shadowen.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Sep 2007 17:11:14.0586 (UTC) FILETIME=[400B0FA0:01C7FBA9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Knowing nothing about these options, from a test perspective it would
> be nice if we were able to simply enable "the lot" so we can do "normal"
> -mm runs and "tiny" -mm runs without any manual intervention?

I agree completely.

I have been thinking for a while about how to make a "monster switch"
(the kind they always seem to have in Frankenstein movies) that
switches a whole bunch of settings at once.  We currently have methods
in the kernel for:
 * default (or recommended) config for a particular platform
 * all yes - to build as much as possible
 * all no - to build as little as possible

The problem with "allno" is that it rarely produces a usable
kernel.

There are three possible approaches that I can think of:
 1) use a tool to start from default and turn off options
 to make a small (but still usable) config
   * I have a tool to do this now as part of my automated test
   I haven't published it, but I can if anyone's interested.
 2) use the kconfig dependency system to disable stuff automatically
 if someone chooses the "make_it_small" option.
 3) create defconfig_small files for the platforms that care about
 size

3) is easiest to implement at first.  It's trivial to make a new
defconfig, and we could easily come up with a convention for them.
However, they would be a pain to maintain (this would essentially
double the defconfig maintenance), and you'd have to convince
people that it's worth carrying these in the mainline tree.

I haven't looked at 2), so I'm not sure exactly what would be
involved.  I'm not sure if you can centralize all the dependency
information in the "make_it_small" option, or if you'd have
to spread it out to the related configs.  I'm not even sure which
arrangement of the info would be the easiest to maintain.  Would
it be best to have a single size-conscious person maintain the
dependencies, or better for config authors to maintain this info
in parallel?

Anyway, those are just some thoughts on the subject.
Feedback on an acceptable solution would be welcome.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

