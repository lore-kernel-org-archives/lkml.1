Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbZJ0UnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbZJ0UnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbZJ0UnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:43:17 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:43129 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbZJ0UnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:43:12 -0400
Subject: Re: [PATCH] ima: remove ACPI dependency
From: David Safford <safford@watson.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       Mimi Zohar <zohar@us.ibm.com>, Stable Kernel <stable@kernel.org>
In-Reply-To: <1256661407.2804.15.camel@dhcp231-106.rdu.redhat.com>
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1256563579-11014-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <7e0fb38c0910270658v153480fdt5ced717feca76c17@mail.gmail.com>
	 <1256659146.3028.29.camel@localhost.localdomain>
	 <1256661407.2804.15.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Oct 2009 16:42:07 -0400
Message-Id: <1256676127.3028.86.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 12:36 -0400, Eric Paris wrote:
> On Tue, 2009-10-27 at 11:59 -0400, David Safford wrote:
> > Basically, if running on a system with a TPM, IMA wants the TPM
> > boot measurement log, which the TPM driver can only get through
> > ACPI. If the platform does not have a TPM, then IMA does not 
> > need ACPI.
> 
> I'm afraid I'm not seeing the connection.  Where does IMA gets the boot
> measurement log?  I see that the TPM exports that log in securityfs as 2
> files (ascii and binary) in tpm_bios.c but I don't see how IMA ever
> makes use of that log either internally to the kernel or through the
> securityfs files.
> 
sorry - bad explanation. IMA reads PCR 0-7, and combines them into
a single "boot_aggregate" as the first entry in the IMA list. For full
attestation, a user level program needs access to both IMA's
boot aggregate, and to the detailed TPM event log upon which
the aggregate is based. So IMA does not itself access the logs,
but the boot aggregate is less useful without them.

As a separate issue, IMA requires the TPM driver to be compiled in
(not loaded as a module) so it is available at IMA initialization, and
the driver apparently requires ACPI in this case. I believe Rajiv
will comment more on this.

dave

> If I'm missing it, and IMA is getting and making use of the bios boot
> log I think we need to instead make the TPM code send a reasonable
> failure code without ACPI and IMA should be changed to handle it.  I
> really don't like the obscure ACPI requirement.

> -Eric


