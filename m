Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbZGGQSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbZGGQSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZGGQRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:17:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:50629 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZGGQRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:17:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,363,1243839600"; 
   d="scan'208";a="162376553"
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>
In-Reply-To: <m1d48kndje.fsf@fess.ebiederm.org>
References: <20090629132926.GB20289@redhat.com>
	 <m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>
	 <m1eit1acxl.fsf@fess.ebiederm.org> <4A4A476C.2070305@redhat.com>
	 <m1ljn94k16.fsf@fess.ebiederm.org> <4A4A6499.9000406@redhat.com>
	 <m1k52t1plq.fsf@fess.ebiederm.org>
	 <1246488808.27006.10691.camel@localhost.localdomain>
	 <m1d48kndje.fsf@fess.ebiederm.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 07 Jul 2009 09:14:40 -0700
Message-Id: <1246983280.27006.10707.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 17:17 -0700, Eric W. Biederman wrote:
> Suresh Siddha <suresh.b.siddha@intel.com> writes:
> > Among number of experiments you have tried in the past to fix this, have
> > you tried the experiment of explicitly clearing the remoteIRR by
> > changing the trigger mode to edge and then back to level.
> >
> > Is there a problem with this?
> 
> The problem I had wasn't remoteIRR getting stuck, but the symptoms
> were largely the same.  I did try changing the trigger mode to edge
> and back and that did not unstick the ioapic in all cases.
> 

I did some experiments locally here yesterday and on my old ICH5 based
system, I couldn't reset the remoteIRR by changing the trigger mode to
edge and then back to level.

However what worked was an explicit eoi to the io-apic using the
respective vector.

I guess we need to try both the things based on perhaps io-apic version
etc.

But what I am nervous about is, did you try both these things aswell and
still saw stuck interrupts?

I will cleanup my code and post it, so that we can try on different
systems. If this still doesn't work on certain HW platforms, atleast our
experiments of what works and what doesn't work and on what platforms
will be documented on the web.

thanks,
suresh

