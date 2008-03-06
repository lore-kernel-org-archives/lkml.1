Return-Path: <linux-kernel-owner+w=401wt.eu-S935416AbYCFSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416AbYCFSL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935306AbYCFSKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:10:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42911 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935264AbYCFSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:10:34 -0500
Subject: [UPDATED v3][PATCH 0/7] regulator: voltage and current regulator
	framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 18:10:30 +0000
Message-Id: <1204827030.15360.146.camel@a10323.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated with comments received from v2. I've also added more in code
comments to hopefully make the review a little easier to read through.

This patch series provides a generic framework to allow device drivers
to control voltage and current regulators on SoC based devices (e.g.
phones, gps, media players).

The intention is to allow systems to dynamically control regulator
output in order to save power and prolong battery life. This applies to
both voltage regulators (where voltage output is controllable) and
current sinks (where current output is controllable).

The framework is designed around SoC based devices but may also be
relevant to non SoC devices. It's also been designed against two Power
Management ICs (PMICs) currently on the market - namely the Freescale
MC13783 and the Wolfson WM8350. However it is quite generic and should
apply to all PMICs. 

The framework provides several interfaces :-

 1. Client or Consumer driver API.

  This uses a similar API to the kernel clock interface in that client
or consumer drivers can get and put a regulator (like they can with
clocks atm) and get/set voltage, current, mode, enable and disable. This
should allow clients complete control over their supply voltage and
current. This API also compiles out if not in use so drivers can be
reused in systems with no PMIC power control.

 2. Regulator driver API.

  This allows regulator drivers to register their regulators and provide
operations to the core. It also has a notifier call chain for
propagating regulator events to clients.

 3. Platform API.

  This API is for platform/device specific code and allows the creation
of voltage/current domains (with constraints) for each regulator. It can
provide regulator constraints that will prevent device damage through
over voltage or over current caused by buggy client drivers.  It also
allows the creation of a regulator tree whereby some regulators are
supplied by others (similar to a clock tree).

 4. Userspace.

  The framework also exports a lot of useful voltage/current data to
userspace via sysfs. This could be used to monitor device and regulator
power and status.

Fwiw, there is a project page here :-

http://opensource.wolfsonmicro.com/node/15

and code in our public git tree that currently shows this API
in use:-

http://opensource.wolfsonmicro.com/cgi-bin/gitweb.cgi?p=linux-2.6-audioplus.git;a=shortlog;h=imx31

Patch follows.

Liam

