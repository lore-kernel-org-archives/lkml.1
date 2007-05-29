Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbXE2Skx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbXE2Skx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXE2SiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:38:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43942 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbXE2SiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:38:12 -0400
Message-Id: <20070529183725.179570071@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 29 May 2007 14:37:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/6] Linux Kernel Markers
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 29 May 2007 18:37:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Linux Kernel Markers have been reworked to now depend on the "Conditional
Calls" as a basic infrastructure for enabling the calls to the function
pointers (probes).

The second major change in this release is the use of a hash table to keep track
of the enabled markers : it permits it issue the marker_arm_probe before loading
a module containing the specified probe. The probe connexion to the marker is
done both when the marker is armed and at module load time. It fixes an
unexpected behavior of the previous version, which was due to the fact that
users might have expected that the markers would be set for newly loaded
modules. Since there is no dependency between the marker and modules, the order
could easily be wrong.

A hash table using a hash of the marker name is used to give O(1) lookup at
module load time.

This serie of patches depends on the conditional calls. Please add at the end of
the 2.6.22-mm1 series:

use-extra_rwdata-in-architectures.patch
#
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-hash-table.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-port-blktrace-to-markers.patch

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
