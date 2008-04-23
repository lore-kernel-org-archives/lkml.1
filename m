Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYDWGIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYDWGIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbYDWGIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:08:20 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:56443 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbYDWGIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sph59OoUYg3GOMyizqWdE9twT5u0tqgMvjIUSmPoOOkOBnrKukA8wz4wErHxWpvQN62kDCUZ/eR/V5arE3B72Y4RIb8INpTdHyjftBBynteeV+r9agSmHIJKQqIblRNEG5cE1ZR1wrIiDUnolLe3FUa8sR9wfAMSDnwgBEVQ8Rw=
Message-ID: <86802c440804222308o7c749e32oa974e24dd0a95bf0@mail.gmail.com>
Date: Tue, 22 Apr 2008 23:08:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: michael@ellerman.id.au
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Greg KH" <greg@kroah.com>,
       "David Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sathya Prakash" <sathya.prakash@lsi.com>
In-Reply-To: <1208928277.9212.1.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804222148.17530.yhlu.kernel@gmail.com>
	 <1208928277.9212.1.camel@concordia.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 10:24 PM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> On Tue, 2008-04-22 at 21:48 -0700, Yinghai Lu wrote:
>  > this change
>  >
>  > | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
>  > | Author: Prakash, Sathya <sathya.prakash@lsi.com>
>  > | Date:   Fri Mar 7 15:53:21 2008 +0530
>  > |
>  > |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
>  > |
>  > |     This patch modifies the driver to enable MSI by default for all SAS chips.
>  > |
>  > |     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
>  > |     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>  > |
>  > cause kexec RHEL 5.1 kernel fail.
>  >
>  > root casue: the rhel 5.1 kernel still use INTx emulation.
>  > and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec path
>  >
>  > so try to call pci_disable_msi in shutdown patch
>
>  How is kdump going to work? Your shutdown routine won't be called and
>  you'll have the same problem in the 2nd kernel, won't you?

for kdump, the first kernel and second kernel should be same version.

this one is for using kexec to load other kernel that may not have msi
support etc.

YH
