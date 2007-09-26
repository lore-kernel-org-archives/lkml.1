Return-Path: <linux-kernel-owner+w=401wt.eu-S1763004AbXIZWhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763004AbXIZWhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763327AbXIZWhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:37:36 -0400
Received: from mga05.intel.com ([192.55.52.89]:5545 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763076AbXIZWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:37:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,199,1188802800"; 
   d="scan'208";a="325842916"
Date: Wed, 26 Sep 2007 15:37:12 -0700
From: Mark Gross <mgross@linux.intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: mgross@linux.intel.com
Subject: [RFC] QoS power Management enabling patch set
Message-ID: <20070926223712.GA22029@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches implement a more generalized infrastructure (than
latency.c) for connecting drivers and subsystem's that could implement
power performance optimizations with the data needed to implement such
policies.

These patches are following up on the discussions and presentations at
the power management summit last summer.

The idea is that from an abstract point of view how much to throttle
hardware can be expressed as a function of QoS types of parameters;
Latency, throughput, and idle time outs.  

The qos_parameter patch is intended to put into place the registration
and notification infrastructure for enabling QoS based policy choices by
drivers, where constraints on throttling are communicated through the
qos_params module.  

Note: it implements a user mode registration protocol where user mode
QoS dependents open a misc device node and write there constraints.  As
long as the file is held open the QoS constraint is included, when the
file closes this constraint is removed and a new constraint is computed.

I would like some feed back on the idea, implementation and possible
applications of this concept we could work on.

The current patch set is 2 patches.
1) qos_param : implements the infrastructure and user mode interface
2) no latency : removes latency.c from the kernel tree replacing it with
qos_param use.

I have a 3rd patch that's a hack application of this qos interface for
communicating latency constraints to e1000.c for tweaking the interrupt
processing of the e1000 based on acceptable latency gathered from the
infrastructure.  I'm not proud of this last one but it helps express the
idea.

Also there is some more documentation and commentary (and an older
patch set) on
http://www.lesswatts.org/projects/power-qos/

thanks,

--mgross

