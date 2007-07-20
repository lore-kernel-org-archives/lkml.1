Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbXGTV71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbXGTV71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXGTV7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:59:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:50569 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbXGTV7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K2GhfcCsSjo0+ZzIiEtzWvuOMcp6K60DXPWpmzIlOJ67w30J8pKrcQx2Ej7VXSKtiaQfsMxx+wVTD71vrkYjPZ48OfYKAI7f9I/m/6s9Tl99FDjLTLBYX/5om83qvkBCRurL3uj+sIPHFQDx9uq37AZJB6t6N80OzYyPVk4cwW4=
Message-ID: <1a297b360707201459s57fb4778m2be80e4c2b825b2c@mail.gmail.com>
Date: Sat, 21 Jul 2007 01:59:01 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Cc: "Roland Dreier" <rdreier@cisco.com>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, jeff@garzik.org,
       "Williams, Dan J" <dan.j.williams@intel.com>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C02B81B3A@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360707201449q73637216w81859b01ab3e5b7e@mail.gmail.com>
	 <BAE9DCEF64577A439B3A37F36F9B691C02B81B3A@orsmsx418.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Nelson, Shannon <shannon.nelson@intel.com> wrote:
> Manu Abraham [mailto:abraham.manu@gmail.com]
> >Sorry for being not clear. What i was asking is thus:
> >
> >A device that has legacy interrupts and MSI-X. I was thinking that if
> >MSI-X failed one should fall back to MSI mode (single message), that's
> >what i was assuming.
> >
> >In such a case, i do enable MSI-X mode on the device, when the request
> >for 2 ^ n  number of messages (where messages can be a max of 32), If
> >the request fails one falls into a single message mode, ie MSI ?
> >
> >
> >> What device do you have in mind?
> >
> >
> >The device that i have in mind is a SAA7160.
>
> Notice our code looks at the return from pci_enable_msix() - it will
> give you a hint whether MSI-X is not supported (returns < 0) or you
> simply asked for too many (returns > 0).  If the former, then fallback
> to legacy; if the latter, try MSI-X with only one interrupt, which
> essentially emulates MSI mode.

Ok. Thanks for clearing it up. So the idea would be that if
pci_enable_msix() for "n" number of messages failed, then settle down
for 1 message, which is equivalent to MSI mode
