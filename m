Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYEPXyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYEPXyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYEPXx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:53:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41874
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbYEPXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:53:55 -0400
Date: Fri, 16 May 2008 16:53:49 -0700 (PDT)
Message-Id: <20080516.165349.255632578.davem@davemloft.net>
To: sparclinux@vger.kernel.org
CC: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2]: Niagara2 RNG driver.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These next two patches implement the RNG driver for Niagara2.
They are also available on the master branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/davem/n2rng-2.6.git

The driver transparently works on both control and guest nodes in
virtualized environments.

I've testedit on both single and dual socket Niagara2 systems, and
rngd seems to be happy with the output.  Below is a typical driver
load and rng stats message log.

Signed-off-by: David S. Miller <davem@davemloft.net>

--------------------
[1102905.419644] n2rng.c:v0.1 (May 15, 2008)
[1102905.419687] n2rng f027a3c8: Registered RNG HVAPI major 2 minor 0
[1102905.419707] n2rng f027a3c8: Found Victoria Falls RNG, units: 2
[1102905.423798] n2rng f027a3c8: Selftest passed on unit 0
[1102905.432773] n2rng f027a3c8: Selftest passed on unit 1
[1102905.432813] n2rng f027a3c8: RNG ready
--------------------
May 16 16:34:07 maramba rngd[4674]: stats: bits received from HRNG source: 500064
May 16 16:34:07 maramba rngd[4674]: stats: bits sent to kernel pool: 440512
May 16 16:34:07 maramba rngd[4674]: stats: entropy added to kernel pool: 440512
May 16 16:34:07 maramba rngd[4674]: stats: FIPS 140-2 successes: 25
May 16 16:34:07 maramba rngd[4674]: stats: FIPS 140-2 failures: 0
May 16 16:34:07 maramba rngd[4674]: stats: FIPS 140-2(2001-10-10) Monobit: 0
May 16 16:34:07 maramba rngd[4674]: stats: FIPS 140-2(2001-10-10) Poker: 0
May 16 16:34:07 maramba rngd[4674]: stats: FIPS 140-2(2001-10-10) Runs: 0
May 16 16:34:07 maramba rngd[4674]: stats: FIPS 140-2(2001-10-10) Long run: 0
May 16 16:34:07 maramba rngd[4674]: stats: FIPS 140-2(2001-10-10) Continuous run: 0
May 16 16:34:07 maramba rngd[4674]: stats: HRNG source speed: (min=425.351; avg=560.278; max=3314.314)Kibits/s
May 16 16:34:07 maramba rngd[4674]: stats: FIPS tests speed: (min=699.644; avg=9559.709; max=20302.755)Kibits/s
May 16 16:34:07 maramba rngd[4674]: stats: Lowest ready-buffers level: 2
May 16 16:34:07 maramba rngd[4674]: stats: Entropy starvations: 0
May 16 16:34:07 maramba rngd[4674]: stats: Time spent starving for entropy: (min=0; avg=0.000; max=0)us
