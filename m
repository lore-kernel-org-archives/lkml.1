Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbZINSnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbZINSnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbZINSni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:43:38 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:43244 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbZINSnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:43:37 -0400
Date: Mon, 14 Sep 2009 12:43:36 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: "Jonathan M. McCune" <jonmccune@cmu.edu>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, jmorris@namei.org,
       tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Fixup pubek sysfs file
Message-ID: <20090914184336.GC25981@obsidianresearch.com>
References: <20090904045231.GW4973@obsidianresearch.com> <adaab1bnvz3.fsf@cisco.com> <20090904140325.c592289a.akpm@linux-foundation.org> <20090904212316.GZ406@obsidianresearch.com> <17754_1252731784_n8C533ou010944_20090911162837.GC17677@kroah.com> <4AAE84EA.8010109@cmu.edu> <1252953279.9372.229.camel@blackbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252953279.9372.229.camel@blackbox>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 03:34:39PM -0300, Rajiv Andrade wrote:

> > Thus, fixing the one-item-per-file issues seems reasonable to me. For 
> > example, changing /sys/devices/platform/tpm_tis/pcrs from a single
> > multi-entry file to a directory containing files named 0-15 or 0-23 that
> > each then contain only the relevant 20-byte value seems quite
> > reasonable. (Today's TPMs contain either 16 or 24 PCRs but future ones
> > could contain many more.)

> The number of PCRs of a particular TPM can be retrieved sending it the
> TPM_GetCapability command, so it's feasible to build this directory
> structure dynamically (chip independent).

I think as we've seen, keeping the sysfs stuff working has a real
cost. So that should be balanced with an actual need. Further, talking
to the TPM and handling all the parsing properly is a huge complex
pain, it would be better to have this code gone completely.

Can anyone think of a reason why the PCRs should be accessed from
sysfs? I can't. They are only really useful in connection with other
complex TPM operations. Userspace can fully access them using the
relevant TPM calls.

The pubek should definately go, it is useless in 99% of cases.

The caps file should be split up into 'manufacturer' 'tcg_version'
(please include the spec rev too!!) and maybe 'firmware_version'. This
would at least be useful to udev.

Regards,
Jason
