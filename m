Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZJ0Qhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZJ0Qhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZJ0Qhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbZJ0Qhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:37:37 -0400
Subject: Re: [PATCH] ima: remove ACPI dependency
From: Eric Paris <eparis@redhat.com>
To: David Safford <safford@watson.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       Mimi Zohar <zohar@us.ibm.com>, Stable Kernel <stable@kernel.org>
In-Reply-To: <1256659146.3028.29.camel@localhost.localdomain>
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1256563579-11014-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <7e0fb38c0910270658v153480fdt5ced717feca76c17@mail.gmail.com>
	 <1256659146.3028.29.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 12:36:47 -0400
Message-Id: <1256661407.2804.15.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 11:59 -0400, David Safford wrote:
> On Tue, 2009-10-27 at 09:58 -0400, Eric Paris wrote:
> > On Mon, Oct 26, 2009 at 9:26 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > > Remove ACPI dependency on systems without a TPM enabled.
> > 
> > I'm confused why you need ACPI at all.  The TPM code doesn't require
> > ACPI (I wish it did but Alan Cox Nak'd that patch).  I don't see acpi
> > anywhere in the ima code.  What's the problem we are solving?  Why
> > does IMA care about ACPI at all?  And aren't you really just dropping
> > the build requirement on TCG_TPM?  Is that a great idea?
> > 
> > -Eric
> 
> This is discussed in the LSM thread:
> http://marc.info/?l=linux-security-module&m=125322062401677&w=2
> 
> Basically, if running on a system with a TPM, IMA wants the TPM
> boot measurement log, which the TPM driver can only get through
> ACPI. If the platform does not have a TPM, then IMA does not 
> need ACPI.

I'm afraid I'm not seeing the connection.  Where does IMA gets the boot
measurement log?  I see that the TPM exports that log in securityfs as 2
files (ascii and binary) in tpm_bios.c but I don't see how IMA ever
makes use of that log either internally to the kernel or through the
securityfs files.

If I'm missing it, and IMA is getting and making use of the bios boot
log I think we need to instead make the TPM code send a reasonable
failure code without ACPI and IMA should be changed to handle it.  I
really don't like the obscure ACPI requirement.

-Eric

