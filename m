Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbYDQGaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbYDQGaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYDQGaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:30:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42740 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYDQGaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:30:01 -0400
Message-ID: <4806EE5F.1040305@firstfloor.org>
Date: Thu, 17 Apr 2008 08:29:51 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: SL Baur <steve@xemacs.org>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: gart: factor out common code
References: <20080415104357.GA13441@elf.ucw.cz>	 <ed10ee420804151625i1e30abb7r98ddda53ec6e8da6@mail.gmail.com>	 <20080416081418.GA5105@elf.ucw.cz> <ed10ee420804161955o221539f9p5cbfcc9eaf4b375d@mail.gmail.com>
In-Reply-To: <ed10ee420804161955o221539f9p5cbfcc9eaf4b375d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SL Baur wrote:
> On 4/16/08, Pavel Machek <pavel@ucw.cz> wrote:
>> On Tue 2008-04-15 16:25:29, SL Baur wrote:
>>  > On 4/15/08, Pavel Machek <pavel@ucw.cz> wrote:
> 
>>  > Other reviewer comments:
>>  > The casting between struct pci_dev * and u64 is kind of ugly,
>>  > I presume the reason for the narrowing casts in the block of
>>  > code you moved is documented somewhere.
>>
>>
>> Where am I doing that?
> 
> The struct pci_dev */u64 casting is in init_k8_gatt.  If Ingo is happy, then
> forget my comment.  I don't have this kind of system to test the patch on, it
> was just that as I was looking it over, all the casts kind of made my head
> swim.

I think the casts make it more clear because the register is 32bit.
The only truly ugly bit is naming a variable "tmp".

> The narrowing cast is here:
> +static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
> +{
> +       u32 tmp, ctl;
> +
> +        /* address of the mappings table */
> +        addr >>= 12;
> +        tmp = (u32) addr<<4;
> 
> Also, putting on my Andrew Morton cap, which I should have done before,
> that function is too big to be inlined so you should probably drop the explicit
> `inline' and let the compiler decide.

In a header static inline is needed, otherwise the compiler will warn
about an unused static if it's not used which is unfortunate because
not every includer wants to use all functions.

That said the function should probably not be in a header.

-Andi
