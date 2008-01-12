Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbYALCtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbYALCtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 21:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760760AbYALCsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 21:48:09 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:57956 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760347AbYALCsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 21:48:07 -0500
Date: Fri, 11 Jan 2008 21:47:37 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 19 0/5] Version 18, series to add device tree naming to i2c
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20080112024737.7023.61680.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.14.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated to reflect comments in:
http://lkml.org/lkml/2008/1/11/272

Since copying i2c-mpc.c to maintain support for the ppc architecture seems to be an issue; instead rework i2c-mpc.c to use CONFIG_PPC_MERGE #ifdefs to support both the ppc and powerpc architecture. When ppc is deleted in six months these #ifdefs will need to be removed.

Another rework of the i2c for powerpc device tree patch. This version implements standard alias naming only on the powerpc platform and only for the device tree names. The old naming mechanism of i2c_client.name,driver_name is left in place and not changed for non-powerpc platforms. This patch is fully capable of dynamically loading the i2c modules. You can modprobe in the i2c-mpc driver and the i2c modules described in the device tree will be automatically loaded. Modules also work if compiled in.

The follow on patch to module-init-tools is also needed since the i2c subsystem has never implemented dynamic loading.
http://lkml.org/lkml/2007/12/17/493

The following series implements standard linux module aliasing for i2c modules on arch=powerpc. It then converts the mpc i2c driver from being a platform driver to an open firmware one. I2C device names are picked up from the device tree. Module aliasing is used to translate from device tree names into to linux kernel names. Several i2c drivers are updated to use the new aliasing. 

--
Jon Smirl
jonsmirl@gmail.com 
