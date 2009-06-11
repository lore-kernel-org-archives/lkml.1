Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZFKE7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZFKE7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 00:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZFKE7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 00:59:46 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:55306 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZFKE7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 00:59:44 -0400
Message-Id: <20090611045829.714510042@jonmasters.org>
User-Agent: quilt/0.47-1
Date: Thu, 11 Jun 2009 00:58:29 -0400
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
Subject: [PATCH 0/1] Hardware Latency Detector (formerly SMI detector)
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jcm@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Please find attached my second re-write of the SMI detector, now called the
Hardware Latency Detector. This is a loadable module that grabs the CPU for
configurable periods of time (all under stop_machine()) and samples the TSC
looking for discontinuity. If observed latencies exceed a threshold (for
example caused by an System Management Interrupt or similar) then the
event is recorded in a global ring_buffer, readable via debugfs.

The previous version was too x86-centric, since there is no reason one could
not also use this newly renamed hwlat_detector on any supported platform with
some kind of underlying firmware/virtualization issues effecting observable
system latency measurements.

Thanks to akpm and others for feedback comments so far.

Changes since the previous version:

- Renamed to hwlat_detector
- Followed Andrew's cleanup advice
- Rewritten the documentation

Jon.
