Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003Ab0ARRif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab0ARRif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774Ab0ARRie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:38:34 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:33327 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab0ARRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:38:33 -0500
MIME-Version: 1.0
In-Reply-To: <1263434836.724.317.camel@pasglop>
References: <4B4DE58D.10008@petalogix.com> <1263434836.724.317.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 18 Jan 2010 10:38:13 -0700
X-Google-Sender-Auth: 968d86f2338ccc08
Message-ID: <fa686aa41001180938k4033bffele6702acfac4a7cd2@mail.gmail.com>
Subject: Re: xilinx-pci driver and pci in general
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: michal.simek@petalogix.com, linuxppc-dev@ozlabs.org, thunderbird2k@gmx.net,
       John Williams <john.williams@petalogix.com>,
       Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 7:07 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2010-01-13 at 16:23 +0100, Michal Simek wrote:
>
>> The main problems are:
>> ppc use ppc_md struct which we don't have it on Microblaze.
>> xilinx-pci driver uses exclude_device function. This function is used in
>> indirect_pci.c too. There could be a way to move that function directly
>> to pci_controller structure which could be useful for other controllers
>> too. What do you think?
>>
>> Then there are some other ppc_md. calling like pcibios_after_init which
>> if I see correctly not used for ppc too.
>
> We may not be using after_init() anymore in which case you are welcome
> to send a patch to remove it :-)
>
> As for the others, well ... maybe you can do wrappers for these that
> call into ppc_md. on powerpc and into some kind of arch_pci_ops. that
> the platform provides on microblaze ?

I agree.  Replace the direct ppc_md. references with arch-provided wrappers.

>> Files contains CONFIG_PPC_OF and we would like to use only CONFIG_OF.
>> I remember any discuss around but not sure what was the conclusion on
>> powerpc.
>
> I think that should be allright, Grant, any objection there ?

None whatsoever.

>> Part of headers are the same that's why there will be a space to move
>> them to asm-generic.
>
> If you can convince other archs that it makes sense to do so ? :-)

Arnd can give you good advice here I think.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
