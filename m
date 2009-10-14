Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZJNSV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZJNSV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZJNSV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:21:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:5357 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbZJNSVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OeoamsOHoboB6euUi1fCIyJezvpN5lpwaW4nzj6J2Jn2q2LzqKqbjF8WdFInLOxoYG
         k3k0svFG+j+0rgBggZk5KK2Euz7lfHcTx6JccMOdqfBa2B8bJhPEQtBghC1WGOzFAV22
         84thqk8nlwoFmfZma+iQbuPOCdTofmNavwbU0=
Date: Wed, 14 Oct 2009 22:20:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86,apic: limit apic dumping, introduce show_lapic
	setup option
Message-ID: <20091014182015.GC5259@lenovo>
References: <20091013200702.019870576@openvz.org> <20091013201022.926793122@openvz.org> <20091014071217.GL784@elte.hu> <20091014150904.GA5259@lenovo> <20091014175616.GA3403@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014175616.GA3403@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Oct 14, 2009 at 07:56:16PM +0200]
...
| 
| noop_default_phys_pkg_id() should return 0 i guess, and not generate a 
| warning?
| 
| 	Ingo
| 

We have
-------
  start_kernel
    setup_arch
      generic_apic_probe
      init_apic_mappings <-- here we change apic to noop driver
    check_bugs <-- noop warn here but apic should be already
                   disabled so it seems some flag is forgotten to set.

All in one: some nit in my patch. Checking...

	-- Cyrill
