Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYLKNlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYLKNlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 08:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYLKNlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 08:41:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:45505 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbYLKNlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 08:41:36 -0500
Message-ID: <154e089b0812110541x26534df0k47b320f54759df8e@mail.gmail.com>
Date: Thu, 11 Dec 2008 14:41:34 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 9/9] mISDN: fix sparse warnings
Cc: "Karsten Keil" <kkeil@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <87hc5cc60n.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493feac3.25e2660a.2824.6cb2@mx.google.com>
	 <87hc5cc60n.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 6:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Hannes Eder <hannes@hanneseder.net> writes:
>> @@ -918,7 +919,7 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
>>       /* Disable sync of all cards */
>>       list_for_each_entry_safe(hc, next, &HFClist, list) {
>>               if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
>> -                     plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
>> +                     plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);
>
> It would be probably better to declare plx_membase __iomem too instead
> of so much casting.

it is, but of type "u_char __iomem *" (after applying this patch):

+       u_char __iomem  *pci_membase; /* PCI memory (MUST BE BYTE POINTER) */

so thats why we need the cast.

What if we declare plx_acc_32 of type "u_char __iomem *", or both as
"void __iomem *"?
I slightly favor the later, against the LOUD comment.

If plx_membase is declared without __iomem the cast "(u_int __iomem*)" produces
a warning "cast adds address space to expression"

-Hannes
