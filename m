Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZGAW4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZGAW4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZGAW4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:56:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:7959 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbZGAW4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:56:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,328,1243839600"; 
   d="scan'208";a="471321798"
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>, garyhade@us.ibm.com
In-Reply-To: <m1k52t1plq.fsf@fess.ebiederm.org>
References: <20090629132926.GB20289@redhat.com>
	 <m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>
	 <m1eit1acxl.fsf@fess.ebiederm.org> <4A4A476C.2070305@redhat.com>
	 <m1ljn94k16.fsf@fess.ebiederm.org> <4A4A6499.9000406@redhat.com>
	 <m1k52t1plq.fsf@fess.ebiederm.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 01 Jul 2009 15:53:28 -0700
Message-Id: <1246488808.27006.10691.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 12:36 -0700, Eric W. Biederman wrote:
> Dropped irqs..  Driver hangs because it is waiting for an irq.  Hardware
> hangs because it is waiting for the cpu to process the irq.
> 
> Potentially we get a level triggered irq that is never acked by
> the cpu that won't arm until the cpu send an ack, and we can't
> send an ack from another cpu.

Eric,

Among number of experiments you have tried in the past to fix this, have
you tried the experiment of explicitly clearing the remoteIRR by
changing the trigger mode to edge and then back to level.

Is there a problem with this?

We can send a spurious IPI (after the RTE migration) with the new vector
to another cpu and handler which services the level interrupt will check
if we saw the edge mode for a level interrupt and then the handler can
explicitly restore the level trigger and reset the remote IRR by mask
+edge and unmask+level.

We might have to work with some rough edges but do you recollect any
major issue with this approach..

thanks,
suresh

