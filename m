Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbXLRCjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbXLRCjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbXLRCja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:39:30 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:45161 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXLRCj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:39:29 -0500
Date: Mon, 17 Dec 2007 21:39:13 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 0/7] Series to add device tree naming to i2c
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20071218023913.8530.46661.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another rework of the i2c for powerpc device tree patch. This version implements standard alias naming only on the powerpc platform and only for the device tree names. The old naming mechanism of i2c_client.name,driver_name is left in place and not changed for non-powerpc platforms. This patch is fully capable of dynamically loading the i2c modules. You can modprobe in the i2c-mpc driver and the i2c modules described in the device tree will be automatically loaded. Modules also work if compiled in.

The follow on patch to module-init-tools is also needed since the i2c subsystem has never implemented dynamic loading.

Since the i2c-mpc driver also supports the ppc architecture the i2c-mpc driver was copied to i2c-mpc-ppc before changes were made. The i2c-mpc-ppc driver should be deleted in six months when the rest of the ppc architecture is removed.

The following series implements standard linux module aliasing for i2c modules on arch=powerpc. It then converts the mpc i2c driver from being a platform driver to an open firmware one. I2C device names are picked up from the device tree. Module aliasing is used to translate from device tree names into to linux kernel names. Several i2c drivers are updated to use the new aliasing. 

--
Jon Smirl
jonsmirl@gmail.com 
