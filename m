Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZF3Sx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZF3Sx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 14:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZF3Sxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 14:53:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58160 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZF3Sxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 14:53:48 -0400
Date: Tue, 30 Jun 2009 21:53:48 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090630185347.GD8122@redhat.com>
References: <20090630064515.GG20289@redhat.com> <86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com> <20090630075457.GH20289@redhat.com> <86802c440906301143s14d0cc9ej9b666271a1ce15ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440906301143s14d0cc9ej9b666271a1ce15ba@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 11:43:41AM -0700, Yinghai Lu wrote:
> 2009/6/30 Gleb Natapov <gleb@redhat.com>:
> 
> >>
> >> how about kexec second kernel in KVM ?
> >>
> >> x2apic_preenabled will be set in second kernel.
> >>
> > Yes, bummer. But the similar problem exist now and without KVM. After
> > running x2apic enabled kernel you can't kexec kernel without x2apic
> > support.
> 
> if the first kernel enable x2apic and intr_remapping, and second
> kernel has x2apic and intr_remap support.
> we can kexec the second kernel.
> 
And if it hasn't we cannot, that is what I am trying to point out.

> restoring to original state is not possible for kdump case.
> 
Shouldn't it be enough to run UP kernel for kdump? So kdump can reset BSP
apic to xAPIC mode before starting a kernel with maxcpus=1.

> maybe with minor change to your patch, you could kexec the in kexec
> second kernel with x2apic support.
> 
My patch can easily avoid the issue by checking max_physical_apicid > 255
instead of x2apic_preenabled.

--
			Gleb.
