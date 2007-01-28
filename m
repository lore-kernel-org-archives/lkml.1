Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXA1WUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXA1WUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932921AbXA1WUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:20:11 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38558 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbXA1WUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:20:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Paul Mackerras <paulus@samba.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/6] msi: Kill msi_lookup_irq
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com>
	<17853.7463.911235.324340@cargo.ozlabs.ibm.com>
Date: Sun, 28 Jan 2007 15:18:55 -0700
In-Reply-To: <17853.7463.911235.324340@cargo.ozlabs.ibm.com> (Paul Mackerras's
	message of "Mon, 29 Jan 2007 09:01:11 +1100")
Message-ID: <m1slduokvk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:

> Eric W. Biederman writes:
>
>> @@ -693,15 +664,14 @@ int pci_enable_msi(struct pci_dev* dev)
>>  	if (!pos)
>>  		return -EINVAL;
>>  
>> -	WARN_ON(!msi_lookup_irq(dev, PCI_CAP_ID_MSI));
>> +	WARN_ON(!!dev->msi_enabled);
>
> Minor nit: what's wrong with just WARN_ON(dev->msi_enabled) ?

It's a bitfield so gcc complains when something in WARN_ON calls
typeof on it.  So it is easier to just say !! than to dig into
WARN_ON and see if it made any sense to fix WARN_ON, or to see if gcc
needed the bug fix.

> Also here:
>
>> @@ -836,16 +811,14 @@ int pci_enable_msix(struct pci_dev* dev, struct
> msix_entry *entries, int nvec)
>>  				return -EINVAL;	/* duplicate entry */
>>  		}
>>  	}
>> -	temp = dev->irq;
>> -	WARN_ON(!msi_lookup_irq(dev, PCI_CAP_ID_MSIX));
>> +	WARN_ON(!!dev->msix_enabled);
>
> Paul.
