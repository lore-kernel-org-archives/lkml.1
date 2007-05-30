Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbXE3PGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbXE3PGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXE3PGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:06:00 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:34812 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbXE3PF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n3zlM7bWvSnwYugLpTFAaH8q5BkAn344C9eSBHk8ZkwEllL9CenEQAe91LoIjO/BPevpRpWcpbRRM+ksH1BdkncndjBm9XMg0b5HUh3N3FAQYRyECy710wkxD9OnqF6cl221ru2xQlusipQiaJ10u+njNaqXoZh/1kgDcCSMkAU=
Message-ID: <a781481a0705300758t5f16235al1f420f09472af780@mail.gmail.com>
Date: Wed, 30 May 2007 20:28:54 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Meelis Roos" <mroos@linux.ee>
Subject: Re: ppc modprost warnings in 2.6.22-rc1
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.SOC.4.64.0705301652250.23769@math>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SOC.4.64.0705141717110.23895@math>
	 <20070515204540.GC22966@uranus.ravnborg.org>
	 <Pine.SOC.4.64.0705301652250.23769@math>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Meelis,

On 5/30/07, Meelis Roos <mroos@linux.ee> wrote:
> > > WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x18) and 'Mesquite_pci_IRQ_map'
> > .....
> >
> > mot_info is only used by functions marked __init.
> > So why not mark it __init so it get discarded and we get rid of all those warnings?
>
> How do I mark a initialized struct __init? Adding __init or const __init in
> front of the declaration results in
>
>   CC      arch/ppc/platforms/prep_pci.o
> arch/ppc/platforms/prep_pci.c:806: error: mot_info causes a section type conflict

Data that is not accessed after initcalls are done (and hence can be
safely freed after kernel boot) must be marked __initdata.

Satyam
