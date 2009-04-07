Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZDGOmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZDGOmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbZDGOld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:41:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:11217 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbZDGOlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yAkOS+T3Xp7dy2LYpg2RYkxYLcQauBo/45Ri2Rbyje9LIClWK/sM7I681S0/RGlDM4
         ldnp7nRXdOpL9a/TkmxwjG2Q3M4guqirwxzJtkoTZmTg4ew7s5PUHyr2W3dRI+l7q3bp
         B4PAG8LPQChhVMyDd0lwd3AJvdF0Bpr0S+Y9Q=
MIME-Version: 1.0
In-Reply-To: <20090407143248.GA21727@parisc-linux.org>
References: <20090407123707.GA18687@orion>
	 <20090407143248.GA21727@parisc-linux.org>
Date: Tue, 7 Apr 2009 18:41:28 +0400
Message-ID: <a4423d670904070741h23ce6d10pf775b67c25f9899d@mail.gmail.com>
Subject: Re: [PATCH next] pci: fix build error with !PCIE_ECRC
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/7 Matthew Wilcox <matthew@wil.cx>:
> On Tue, Apr 07, 2009 at 04:37:08PM +0400, Alexander Beregalov wrote:
>> Fix this build error:
>> drivers/built-in.o: In function `pci_init_capabilities':
>> drivers/pci/probe.c:989: undefined reference to `pcie_set_ecrc_checking'
>> drivers/built-in.o: In function `pci_setup':
>> drivers/pci/pci.c:2547: undefined reference to `pcie_ecrc_get_policy'
>
>>  config PCIE_ECRC
>>       bool "PCI Express ECRC support"
>> -     depends on PCI
>> +     depends on PCI && PCIEPORTBUS
>
> How does this part of the patch relate to the above description?

Right, I agree. This should be another patch "PCIE_ECRC should depend on PCIE"

When I found this problem PCIE_ECRC was set, but was not be built in.
My problem needs both patches to be fixed, I will send them few hours later.
