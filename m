Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYFPFnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYFPFnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 01:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbYFPFnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 01:43:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:13000 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbYFPFnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 01:43:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xYaAAH1DM9FdCYOfXz6pf5XfdsPnNWmeRzuT7DQ574P36TXNk1qMZ9W5IdcOWb2urf
         NbDmwhrENOdBbNivmF1Mi4hHpg9qZjVD8pbQlLY3mMkgFxcbVlVNruA7ycWY/0xjCD6W
         OzIwBvZ6OshGDx/eqKkG3wK3izh0oNPhOBuGw=
Message-ID: <86802c440806152243j7b31a62wfef8b4cb6a6c11f1@mail.gmail.com>
Date: Sun, 15 Jun 2008 22:43:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high pages init
Cc: "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4855FC70.9050900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806132005.45836.yhlu.kernel@gmail.com>
	 <200806140056.32601.yhlu.kernel@gmail.com>
	 <20080614082343.GB11277@elte.hu>
	 <86802c440806140205g3ff113ffq39272c18ef5b9654@mail.gmail.com>
	 <1213579241.2433.7.camel@caritas-dev.intel.com>
	 <86802c440806152046s71916de8g6f8e3e8d272d336a@mail.gmail.com>
	 <1213594669.10376.19.camel@caritas-dev.intel.com>
	 <4855FC70.9050900@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 10:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Huang, Ying wrote:
>>
>> On Sun, 2008-06-15 at 20:46 -0700, Yinghai Lu wrote:
>> [...]
>>>
>>> don't need,
>>> EFI memmap should be reserved in e820map, so it should not show up in
>>> early_node_map.
>>
>> I don't think so. EFI memmap comes from boot-loader not from BIOS. It
>> contains boot-loader execution information (such as EfiLoaderCode,
>> EfiLoaderData, etc), and it will be located at different position for
>> each system reboot.
>>
>> If it is reserved in E820 memmap, hibernation can not work. Because the
>> memory area for EFI memmap is not E820 RAM, it is not saved during
>> hibernating and restored after restoring from disk.
>>
>> Linked list of struct setup_data has similar requirement too.
>>
>
> That doesn't mean we can't use the E820 memory map structure for it.  We
> just have to define a new kernel-internal memory type, instead of using type
> 2 (reserved).

yes. then just modify e820_mark_nosave_regions a little bit.

YH
