Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYDVQGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYDVQGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759232AbYDVQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:06:44 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:6006 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYDVQGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:06:43 -0400
From: "Fischer, Anna" <anna.fischer@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Apr 2008 16:06:02 +0000
Subject: Duplicate SYSFS entries???
Thread-Topic: Duplicate SYSFS entries???
Thread-Index: AcikksL7JShjfHaYTFWhfXNELnp8qg==
Message-ID: <38CBA1F6A350B044AF785E63AAC3C6776497AFEB5C@G5W0276.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm creating a SYSFS hierarchy that consists of several symlinks that I'm generating by calling sysfs_create_link(). However, I realized that when I'm calling this with a link name that is already in the directory, I actually don't get an error back but the kernel creates another symlink with the same name, but the destination of the link is arbitrary. For example, this has created the following structure under SYSFS on my system:

ls -l /X

total 0
lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:13:21:1f:2d:35 -> ../../../vnetmod/vms/vm0
lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:50:56:19:a6:01 -> ../../../vnetmod/vms/vm13
lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:50:56:19:a6:01 -> ../../../vnetmod/vms/vm13
lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:50:56:19:a6:01 -> ../../../vnetmod/vms/vm13
lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:50:56:19:a6:01 -> ../../../vnetmod/vms/vm13


Actually, I have created the symlinks with different target directories but they all (obviously) point to the same one (vm13). Shouldn't the kernel return an error code and disallow the creation of multiple files (or symlinks) with the same name in the same directory??

I'm running kernel version 2.6.16.13-4-smp #1 SMP Wed May 3 04:53:23 UTC 2006 x86_64 x86_64 x86_64 GNU/Linux.

Many thanks,
Anna
