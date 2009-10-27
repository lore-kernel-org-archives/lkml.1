Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbZJ0U5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbZJ0U5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbZJ0U5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:57:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbZJ0U5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:57:33 -0400
Subject: Re: [PATCH] ima: remove ACPI dependency
From: Eric Paris <eparis@redhat.com>
To: David Safford <safford@watson.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       Mimi Zohar <zohar@us.ibm.com>, Stable Kernel <stable@kernel.org>
In-Reply-To: <1256676127.3028.86.camel@localhost.localdomain>
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1256563579-11014-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <7e0fb38c0910270658v153480fdt5ced717feca76c17@mail.gmail.com>
	 <1256659146.3028.29.camel@localhost.localdomain>
	 <1256661407.2804.15.camel@dhcp231-106.rdu.redhat.com>
	 <1256676127.3028.86.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 16:56:50 -0400
Message-Id: <1256677010.10981.3.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 16:42 -0400, David Safford wrote:
> On Tue, 2009-10-27 at 12:36 -0400, Eric Paris wrote:
> > On Tue, 2009-10-27 at 11:59 -0400, David Safford wrote:
> > > Basically, if running on a system with a TPM, IMA wants the TPM
> > > boot measurement log, which the TPM driver can only get through
> > > ACPI. If the platform does not have a TPM, then IMA does not 
> > > need ACPI.
> > 
> > I'm afraid I'm not seeing the connection.  Where does IMA gets the boot
> > measurement log?  I see that the TPM exports that log in securityfs as 2
> > files (ascii and binary) in tpm_bios.c but I don't see how IMA ever
> > makes use of that log either internally to the kernel or through the
> > securityfs files.
> > 
> sorry - bad explanation. IMA reads PCR 0-7, and combines them into
> a single "boot_aggregate" as the first entry in the IMA list. For full
> attestation, a user level program needs access to both IMA's
> boot aggregate, and to the detailed TPM event log upon which
> the aggregate is based. So IMA does not itself access the logs,
> but the boot aggregate is less useful without them.

So users of IMA in userspace may want TPM.  Shouldn't the kernel really
have this as a depends/select in the TPM code?  This isn't IMA specific,
it's TPM specific.  Obviously I'm not a fan of the spurious ACPI
requirement in the IMA code.  How about a 'CONFIG_TPM_BIOS_LOG' or
something which selects ACPI?  We'll see what Rajiv thinks.

> As a separate issue, IMA requires the TPM driver to be compiled in
> (not loaded as a module) so it is available at IMA initialization, and
> the driver apparently requires ACPI in this case. I believe Rajiv
> will comment more on this.

I know it's required to be built in.  Didn't know that required ACPI,
but if so, that's a good reason to push this to the TPM code and get it
out of the IMA code....

