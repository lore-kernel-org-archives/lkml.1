Return-Path: <linux-kernel-owner+w=401wt.eu-S1762703AbXGMQqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703AbXGMQqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbXGMQpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:45:54 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:12720 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751876AbXGMQpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:45:53 -0400
Date: Fri, 13 Jul 2007 10:52:09 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, greg@kroah.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 0/8] drivers edac sysfs fixes
Message-ID: <4697adb9.K4EBs8btTto1Gz+B%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This EDAC patch set was applied against: 2.6.22-rc6-mm1

This series of EDAC patches fixes sysfs completion operation as found during
a review of the last -mm submission, and a new low level chipset driver

1) These fixes dealt with EDAC sysfs operation, namely the exiting/releasing of
sysfs objects by the edac core driver, for edac_mc and edac_device classes.

This removes "completion call" operations on sysfs teardown.

The sysfs code now bumps the ref count on the main kobject of each control 
structure to count internal kobjects. The main kobject bumps the 
edac_core module once at its creation waiting until its ref count
goes to zero.  At that point, the control struct is kfree() and
the EDAC CORE module ref count is decrement, thus allowing the 
module to be unloaded.

2) Another fix required some additional simple mods on the edac alloc() and
finalization APIs mods which led to altering all the in tree drivers to
comform. This was necessary to allow the sysfs solution to work correctly

3) A new PASEMI driver is also included in this patch set

