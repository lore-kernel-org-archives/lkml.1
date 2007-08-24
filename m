Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbXHXUC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbXHXUC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXHXUCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:02:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:5089 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbXHXUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PihYzsJpB51DFwn3137weNIkOvpIXT0sCxzyRW7H2O5UPcqwP6h6LgbNOPPiMNefPNdhMatFGUaeIFwb85eRa89a/BBWh1E78cxOpAsvGYtgyvD8WD1n6B6U4M8D8w6SMfI5KJ3g9GLb23EhlUuD1wTDm2HfXBmiFpO3BJa1S7Q=
Message-ID: <46CF399E.3010808@gmail.com>
Date: Fri, 24 Aug 2007 22:03:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, postfail@hushmail.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] /drivers/char sx.c ioremap -> pci_ioremap api
References: <46CF2849.2090008@gmail.com>	<4af2d03a0708241159v56b46299h46df9777a98590e5@mail.gmail.com> <20070824201530.5d741b37@the-village.bc.nu>
In-Reply-To: <20070824201530.5d741b37@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox napsal(a):
> ase, 0x80);
>> remove also the hwbase var.
>>
>>> +	rebase = pci_iomap(pdev, 0, 0x80);
>>>   	t = readl(rebase + CNTRL_REG_OFFSET);
> 
> Switch to ioread* if you are using the iomap interface. Its not a trivial

Why, if you know it's surely a mem region (and thus you rely on it and do
ioremap)? There are many places in the kernel, where this approach is used, e.g.
libata piix.

> conversion and its slower and bulkier - the original ioremap was much
> better

at least get rid of the reading the hwbase address from pci conf space, use
pci_resource_start instead.

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
