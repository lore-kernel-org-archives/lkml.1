Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbZEFOq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbZEFOq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZEFOqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:46:47 -0400
Received: from science.horizon.com ([192.35.100.1]:61224 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753559AbZEFOqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:46:47 -0400
Date: 6 May 2009 10:46:45 -0400
Message-ID: <20090506144645.30215.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: johnstul@us.ibm.com
Subject: Re: [RFC][PATCH] Adjust SHIFT_PLL to improve NTP convergence.
Cc: linux-kernel@vger.kernel.org, linux@horizon.com, tglx@linutronix.de,
       ulrich.windl@rz.uni-regensburg.de, williams@redhat.com,
       zippel@linux-m68k.org
In-Reply-To: <1241471016.7444.80.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As always, feedback or testing (especially on non-x86 arches) would be
> greatly appreciated.

Applying it to a couple of PPS-synchronized machines (where I had already
dropped the poll interval into the basement for better convergence, have
to try reverting that) seems to be working.

One thing I just noticed, although I'm sure it has happened in the past,
is that there's a frequency jump each boot due to TSC recalibration.

		Machine 1	Machine 2
Old CPU MHz	2500.170	2500.138
Old NTP ppm	-24.63 +/-0.01	-30.27 +/-0.02

New CPU MHz	2500.176	2500.193
New NTP ppm	-22.26 +/-0.01	-8.20 +/-0.015 

"True" CPU MHz	2500.2316	2500.2136

I should look and see if there's an easy way to tighten that tolerance.
The current algorithm is fine for jiffies purposes, but a few seconds'
worth of background calibration would produce a more stable estimate.
