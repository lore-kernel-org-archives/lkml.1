Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZJ1UrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZJ1UrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbZJ1UrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:47:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58284 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbZJ1UrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:47:24 -0400
Message-ID: <4AE8ADCF.6090104@austin.ibm.com>
Date: Wed, 28 Oct 2009 15:47:11 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6 v5] Kernel handling of Dynamic Logical Partitioning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-send of the entire patch set with updates made from recent
comments received.

The Dynamic Logical Partitioning (DLPAR) capabilities of the powerpc pseries
platform allows for the addition and removal of resources (i.e. cpus,
memory, pci devices) from a partition. The removal of a resource involves
removing the resource's node from the device tree and then returning the
resource to firmware via the rtas set-indicator call.  To add a resource, it
is first obtained from firmware via the rtas set-indicator call and then a
new device tree node is created using the ibm,configure-coinnector rtas call
and added to the device tree.

The following set of patches implements the needed infrastructure to have the
kernel handle the DLPAR addition and removal of memory and cpus (other
DLPAR'able items to follow in future patches).  The framework for this is
to create a set of probe/release sysfs files that will facilitate
arch-specific call-outs to handle addition and removal of cpus and memory to
the system.

Patches include in this set:
1/6 - DLPAR infracstructure for powerpc/pseries platform.
2/6 - Move the of_drconf_cell struct to prom.h
3/6 - Create memory probe/release files and the powerpc handlers for them
4/6 - Memory DLPAR handling
5/6 - Create sysfs cpu probe/release files and the powerpc handlers for them 
6/6 - CPU DLPAR handling

-Nathan Fontenot 
