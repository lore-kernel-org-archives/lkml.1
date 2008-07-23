Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYGWSL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYGWSL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYGWSLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:11:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:56282 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYGWSLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uLuJGTrI1g25ll8F4a4XM2EzYUtwwOS7PCXpRGF5rJvbgfupiclAHglD1uqJXb440z
         QA9VQxLGD+tBzeuKLOP8ZRJEtk6tyKrDwB8yGEBZpI61vzzAJl2XMsciS/H41Uhwf+xy
         C5zkYoaXaFkFuJDF7p1gq00FIkaGHXkwVNRPc=
Message-ID: <b637ec0b0807231111o133ad391k79acceb777c2e7a6@mail.gmail.com>
Date: Wed, 23 Jul 2008 20:11:47 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: New conflict message in latest GIT
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>
In-Reply-To: <4886E540.2070106@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
	 <48863C46.1060704@keyaccess.nl> <48863FB4.9080500@keyaccess.nl>
	 <b637ec0b0807230017w39ecd5bapc9a6afe29a39d5f3@mail.gmail.com>
	 <4886E540.2070106@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene.
I can only confirm that Linus' tree  2.6.26-06077-gc010b2f
(commit c010b2f... Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6)
shows the message.

Grepping the file you suggested gives:

fcomolli@hawking:~/software/GIT-TREES/linux-2.6/drivers/pnp> egrep
'RESOURCE_IO|RESOURCE_MEM' quirks.c
		    option->type == IORESOURCE_IO) {
			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM) ||
			     (res = pnp_get_resource(dev, IORESOURCE_MEM, j));
fcomolli@hawking:~/software/GIT-TREES/linux-2.6/drivers/pnp>

so both IORESOURCE_IO and IORESOURCE_MEM are present in the file...

But definitely this is Linus' tree.
Cheers,
Fabio

On Wed, Jul 23, 2008 at 10:01 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 23-07-08 09:17, Fabio Comolli wrote:
>
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/broken-out/pnp-have-quirk_system_pci_resources-include-io-resources.patch
>>
>> I did not add it manually for sure. By the way, I don't see any ACPI
>> related problems with this kernel.
>
> You can just look at drivers/pnp/quirks.c:quirk_system_pci_resources() and
> see if it's still IORESOURCE_MEM only (current linus) or includes
> IORESOURCE_IO resources as per that patch.
>
> Had a momentary notion that if we specifically exclude ACPI in favour of PCI
> as that patch does this could _cause_ the message -- before, the PCI smbus
> driver just would've failed but perhaps you don't even have such a driver or
> something.
>
> Probably way of base. Just had a deja vu to my own soundcard trouble.
>
> Rene
>
