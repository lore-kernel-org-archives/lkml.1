Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbXGRJmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbXGRJmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXGRJmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:42:25 -0400
Received: from mail.suse.de ([195.135.220.2]:52075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbXGRJmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:42:24 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Joachim Deguara" <joachim.deguara@amd.com>
Subject: Re: [PATCH 0/2] faking and fixing the NUMA SLIT
Date: Wed, 18 Jul 2007 11:42:20 +0200
User-Agent: KMail/1.9.6
Cc: "lkml List" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       lenb@kernel.org, "Christoph Lameter" <clameter@sgi.com>
References: <200707181130.01861.joachim.deguara@amd.com>
In-Reply-To: <200707181130.01861.joachim.deguara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707181142.20811.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 11:30:01 Joachim Deguara wrote:
> The problem with NUMA distances in the SLIT is that they are often wrong, oh 
> wait they aren't there at all because the BIOS didn't create a SLIT since 
> Windows does not use it.  If Linux does not find a slit it just says the 
> distance to local=10 and remote=20 according to ACPI spec.  The problem is 
> when we have a 4P system (or larger), there is generally one node where we 
> have two hops and its distance should be >20.
> 
> Following are patches to first fake the SLIT in the ACPI code and then add 
> ability to write the distances from sysfs.

The main use for the SLIT information are the zone fallback lists in 
the VM. These are created at boot.  If you change the SLIT later these
won't be regenerated. 

The scheduler also uses it for load balancing, but it is much less
important there than in the VM.

The only use would be for libnuma applications that read the SLIT later,
but I'm not aware of any.

Don't think that is really useful.

If anything you would probably need a early boot option for this, but that
would become so ugly that I would rather ask for fixing the BIOSes.
Or implement true node hotplug, but that would be also a lot of work.

On 4S it should not make that much difference anyways and 8S is hopefully
ok.

-Andi
