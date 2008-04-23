Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYDWRc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYDWRc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYDWRcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:32:20 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:4224 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752961AbYDWRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dN1TVIDeoLmY+HtiTaH59OhyHo3T2FCZ+pCTrZoTFa0VJquhTDwVVwKdYp6HsTc/shL6pu5k4exR5ZkwKUcohWUiLSAnZ6RDPsjeVKtYqb7EzLvn2tzGMT7JnlNze2x2yETb3Nhsyil/mZ8adEk2C/fcEIIAv8uU+bF9dI0Qn0g=
Message-ID: <86802c440804231032j53874853p9c0beee956d10f91@mail.gmail.com>
Date: Wed, 23 Apr 2008 10:32:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Greg KH" <greg@kroah.com>,
       "David Miller" <davem@davemloft.net>, "Jeff Garzik" <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sathya Prakash" <sathya.prakash@lsi.com>
In-Reply-To: <m1prsgohj9.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804222148.17530.yhlu.kernel@gmail.com>
	 <m1prsgohj9.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 5:57 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yhlu.kernel.send@gmail.com> writes:
>
>  > this change
>  >
>  > | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
>  > | Author: Prakash, Sathya <sathya.prakash@lsi.com>
>  > | Date:   Fri Mar 7 15:53:21 2008 +0530
>  > |
>  > |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
>  > |
>  > | This patch modifies the driver to enable MSI by default for all SAS chips.
>  > |
>  > |     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
>  > |     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>  > |
>  > cause kexec RHEL 5.1 kernel fail.
>  >
>  > root casue: the rhel 5.1 kernel still use INTx emulation.
>  > and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec
>  > path
>  >
>  > so try to call pci_disable_msi in shutdown patch
>
>  Ok this looks like a reasonable approach.
>
>  Could you please change how this is factored.
>  And implement a pci_shutdown_msi and a pci_shutdown_msix that
>  just performs the hardware state change.
>
>  Then have pci_disable_msi and pci_disable_msix call them?
>
>  That should be much easier to maintain then a adding a function
>  that takes a magic flag.
>
>  That is the design of the shutdown interface and it seems to
>  work well.

will check that.

YH
