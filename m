Return-Path: <linux-kernel-owner+w=401wt.eu-S934357AbZIODGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbZIODGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 23:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934343AbZIODGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 23:06:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37113 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934334AbZIODGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 23:06:25 -0400
Subject: Re: [tpmdd-devel] [PATCH] TPM: Fixup pubek sysfs file
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Jonathan M. McCune" <jonmccune@cmu.edu>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, jmorris@namei.org,
       tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
       Andrew Morton <akpm@linux-foundation.org>, Roland.Dreier@us.ibm.com
In-Reply-To: <20090914194626.GF25981@obsidianresearch.com>
References: <20090904045231.GW4973@obsidianresearch.com>
	 <adaab1bnvz3.fsf@cisco.com>
	 <20090904140325.c592289a.akpm@linux-foundation.org>
	 <20090904212316.GZ406@obsidianresearch.com>
	 <17754_1252731784_n8C533ou010944_20090911162837.GC17677@kroah.com>
	 <4AAE84EA.8010109@  <20090914194626.GF25981@obsidianresearch.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 23:06:23 -0400
Message-Id: <1252983983.3745.67.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 13:46 -0600, Jason Gunthorpe wrote: 
> On Mon, Sep 14, 2009 at 03:23:09PM -0400, Jonathan M. McCune wrote:
> 
> >> Can anyone think of a reason why the PCRs should be accessed from
> >> sysfs? I can't. They are only really useful in connection with other
> >> complex TPM operations. Userspace can fully access them using the
> >> relevant TPM calls.

> > Fair enough, though they are useful in combination with IMA and as a  
> > sanity check that the driver is working correctly.

The IMA ltp testsuite currently uses the sysfs PCR values 0-7 to
validate the boot aggregate, the first measurement in the the IMA
measurement list. 

> [..]
> > IMA can leverage the ability to read and extend PCRs, and its security  
> > properties derive from that functionality being a part of the kernel.  
> > PCR reading is currently part of the TPM driver in 
> > drivers/char/tpm/tpm.c.
> 
> Sanzzy
> 
> > Thus, to the question, "Can we remove the ability of the kernel to send  
> > TPM commands such as GetCapability and PCRRead?" I believe the answer is  
> > no. Or at least, not without causing a lot of work for the IMA system.

Definitely! On boot, IMA reads pcr 0-7 to calculate the boot aggregate.
IMA then extends the PCR, normally PCR-10, with the boot aggregate and
stores it as the first measurement in the IMA measurement list. Each
subsequent measurement, based on policy, extends the PCR and is appended
to the IMA measurement list. 
  
> > Although it may be worth discussing whether this functionality should be  
> > moved from the driver into IMA.

Are you really suggesting moving the tpm_pcr_read()/extend() to IMA?
Why?

> Fair enough, fortunately TPM_PCRRead and TPM_Extend are two of the
> simplest commands. As has been done special casing the fixed size
> messages is easy and robust.

Mimi

