Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbYGRRyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbYGRRyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYGRRy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:54:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:43930 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbYGRRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZiWVfJuPpfetXGXCAqpYUIaroHwSGgK+vyzkRmz5Kevsa9dBdrdRg9JNClcQSDNEHY
         sKWhQLJVa4f69EuBiWonkn3YBioPp/kbBMs9116O8EQVp4ubO9pJvHF4ZhY1U4qKY7ia
         36FYLnPK1ApsQZRVOW3v8MnIk5RxeTz3rYRF8=
Message-ID: <86802c440807181054p422a77bdv901ebdc44a8d1b43@mail.gmail.com>
Date: Fri, 18 Jul 2008 10:54:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       jbarnes@virtuousgeek.org, "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4880D7B9.8000007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807180941.09779.yhlu.kernel@gmail.com>
	 <4880D684.7020406@zytor.com>
	 <86802c440807181047y4ef2f227me72e6474e726596@mail.gmail.com>
	 <4880D7B9.8000007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 10:49 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> On Fri, Jul 18, 2008 at 10:44 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> Yinghai Lu wrote:
>>>>
>>>> change the mconf bus range from [0,0xff] to to [0, 0x3f]
>>>> to match range [0xf0000000, 0xf4000000) in e820 tables.
>>>>
>>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>>> Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
>>>
>>> Why is this hard-coded instead of discovered dynamically?
>>
>> you mean according to the range reserved in e820 to find out bus range
>> that should be used for mmconf?
>
> That would make sense, since you're truncating the mmconf range based on
> some arbitrary limit.  Even better would be to query the hardware register
> which is responsible for the truncation.

OK

will rework pci_mmcfg_reject_broken to
reduce size and check with is_acpi_reserved/e820_mapped to update end_bus_number

YH
