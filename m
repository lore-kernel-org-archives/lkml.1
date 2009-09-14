Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZINTqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZINTqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 15:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZINTqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 15:46:32 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:49744 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756887AbZINTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 15:46:31 -0400
Date: Mon, 14 Sep 2009 13:46:26 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Jonathan M. McCune" <jonmccune@cmu.edu>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, jmorris@namei.org,
       tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>, Reiner Sailer <sailer@us.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Fixup pubek sysfs file
Message-ID: <20090914194626.GF25981@obsidianresearch.com>
References: <20090904045231.GW4973@obsidianresearch.com> <adaab1bnvz3.fsf@cisco.com> <20090904140325.c592289a.akpm@linux-foundation.org> <20090904212316.GZ406@obsidianresearch.com> <17754_1252731784_n8C533ou010944_20090911162837.GC17677@kroah.com> <4AAE84EA.8010109@cmu.edu> <1252953279.9372.229.camel@blackbox> <20090914184336.GC25981@obsidianresearch.com> <4AAE981D.2020809@cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAE981D.2020809@cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 03:23:09PM -0400, Jonathan M. McCune wrote:

>> Can anyone think of a reason why the PCRs should be accessed from
>> sysfs? I can't. They are only really useful in connection with other
>> complex TPM operations. Userspace can fully access them using the
>> relevant TPM calls.
>
> Fair enough, though they are useful in combination with IMA and as a  
> sanity check that the driver is working correctly.
[..]
> IMA can leverage the ability to read and extend PCRs, and its security  
> properties derive from that functionality being a part of the kernel.  
> PCR reading is currently part of the TPM driver in 
> drivers/char/tpm/tpm.c.

Sanzzy

> Thus, to the question, "Can we remove the ability of the kernel to send  
> TPM commands such as GetCapability and PCRRead?" I believe the answer is  
> no. Or at least, not without causing a lot of work for the IMA system.  
> Although it may be worth discussing whether this functionality should be  
> moved from the driver into IMA.

Fair enough, fortunately TPM_PCRRead and TPM_Extend are two of the
simplest commands. As has been done special casing the fixed size
messages is easy and robust.

The pcrs file really isn't that offsensive to me, the PCR registers
can reasonably thought of as a single memory space. If it wasn't for
the PCR-%u prefix I think it would be fine for sysfs??

Ie:

BD ED 7B B2 EB AE BE 31 4E CC 57 82 81 64 FC 8A 09 FA 19 25 
05 37 25 B5 24 59 14 A5 94 1A 42 97 39 E6 07 40 27 3A 7D 48 
3A 3F 78 0F 11 A4 B4 99 69 FC AA 80 CD 6E 39 57 C3 3B 22 75 

not:

PCR-00: BD ED 7B B2 EB AE BE 31 4E CC 57 82 81 64 FC 8A 09 FA 19 25 
PCR-01: 05 37 25 B5 24 59 14 A5 94 1A 42 97 39 E6 07 40 27 3A 7D 48 
PCR-02: 3A 3F 78 0F 11 A4 B4 99 69 FC AA 80 CD 6E 39 57 C3 3B 22 75 

Greg?

Jason
