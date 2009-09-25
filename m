Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZIYIx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZIYIx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZIYIx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:53:59 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:59711 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZIYIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:53:58 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v6 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
 management code in x86, cleanup drivers/cpuidle/cpuidle.c and introduce
 cpuidle to POWER.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Arjan van de Ven <arjan@infradead.org>, arun@linux.vnet.ibm.com,
       Len Brown <lenb@kernel.org>, Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20090925070623.GH8595@dirshya.in.ibm.com>
References: <20090922112526.GA7788@linux.vnet.ibm.com>
	 <20090924051238.GA5963@linux.vnet.ibm.com>
	 <20090924142228.5a2ddf59@infradead.org>
	 <20090925070623.GH8595@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Fri, 25 Sep 2009 10:54:24 +0200
Message-Id: <1253868864.10287.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 12:36 +0530, Vaidyanathan Srinivasan wrote:
> * Arjan van de Ven <arjan@infradead.org> [2009-09-24 14:22:28]:
> 
> > On Thu, 24 Sep 2009 10:42:41 +0530
> > Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:
> > 
> > > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 16:55:27]:
> > > 
> > > Hi Len, (or other acpi folks),
> > > 
> > > I had a question regarding ACPI-cpuidle interaction in the current
> > > implementation.
> > > 
> > > Currently, every cpu (i.e. acpi_processor) registers to cpuidle as
> > > a cpuidle_device. So every cpu has to go through the process of
> > > setting up the idle states and then registering as a cpuidle device.
> > > 
> > > What exactly is the reason behind this?
> > > 
> > 
> > technically a BIOS can opt to give you C states via ACPI on some cpus,
> > but not on others.
> > 
> > in practice when this happens it tends to be a bug.. but it's
> > technically a valid configuration
> 
> So we will need to keep the per-cpu registration as of now because we
> may have such buggy BIOS in the field and we don't want the cpuidle
> framework to malfunction there.

If the BIOS doesn't mention a certain C state on a cpu, and you try to
set it anyway, does that go boom?

This whole per-cpu registration thing is horridly ugly, can't you have a
per-cpu C state exception mask and leave it at that -- if its really
needed?



