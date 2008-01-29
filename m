Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbYA3HI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbYA3HI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYA3HIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:08:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:47316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYA3HIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:08:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,275,1199692800"; 
   d="scan'208";a="331996297"
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <479F4B99.4060701@zytor.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	 <479F4B99.4060701@zytor.com>
Content-Type: text/plain
Organization: Intel
Date: Wed, 30 Jan 2008 05:56:57 +0800
Message-Id: <1201643817.12722.30.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 07:51 -0800, H. Peter Anvin wrote:
> Yi Yang wrote:
> > Current cpuid module will create a char device for every logical cpu,
> > when a user cats /dev/cpu/*/cpuid, he/she will enter a limitless loop,
> > the root cause is that cpuid module doesn't decide wether a cpuid level
> > is valid, it just uses an offset to denote cpuid level and take it to
> > cpuid instruction, cpuid instruction will ignore it and return some data
> > 
> > This patch uses sysfs to avoid limitless loop and provide more flexible
> > interface for cpuid, please consider to merge to -mm tree in order to test.
> 
> This is broken.
> 
> Triple broken.
> 
> It's broken, because it doesn't take into account the fact that Intel 
> broke CPUID level 4 and made it "repeating" (neither did the cpuid char 
> device, because it predated the Intel braindamage; I've had a patch for 
> it privately for a while, but didn't push it upstream because paravirt 
> broke it royally and I wanted the situation to settle down.)
level 4 doesn't result in repeating on Intel CPU, cpuid module sets
file offset to level, so cat /dev/cpu/*/cpuid will run cpuid instruction
continuously.

