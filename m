Return-Path: <linux-kernel-owner+w=401wt.eu-S1031196AbXECNmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031196AbXECNmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031248AbXECNmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:42:50 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:26909 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031196AbXECNmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:42:49 -0400
Date: Thu, 3 May 2007 15:42:10 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Nathan Lynch <ntl@pobox.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, ashok.raj@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: /sys/devices/system/cpu/*: Present cpus or Possible cpus
Message-ID: <20070503134210.GA7694@osiris.boeblingen.de.ibm.com>
References: <20070502110022.GA13040@in.ibm.com> <20070502163757.GF30688@localdomain> <20070502185235.GA6859@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502185235.GA6859@in.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 12:22:35AM +0530, Gautham R Shenoy wrote:
> On Wed, May 02, 2007 at 11:37:57AM -0500, Nathan Lynch wrote:
> > Hi Gautham-
> > 
> > I believe that the powerpc behavior was established before
> > cpu_present_map was introduced.
> 
> Ok. I guess the same is the reason with a few other architectures like 
> s390.

No, the reason for s390 is that we don't get any notification if
a new cpu gets attached, if running under z/VM (a hypervisor).
But since the cpuX/online attribute must exist to bring a cpu
online, the idea was to create the directories for all possible
cpus and if somebody tries to online a cpu the code will scan
for present and unused cpus and uses the first one...
Kind of stupid, but works.
