Return-Path: <linux-kernel-owner+w=401wt.eu-S1759643AbYETDWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643AbYETDWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 23:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYETDWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 23:22:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:58949 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbYETDWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 23:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HneLu1ZwRrNPMQ9Ok20I0QmKNo6HMxmIyuEIsi0Kf+qPgr4B+mOyVQMxOFmdyJtG6iLLe0lvUlwHtcURXbB736F6wmNheksD2/53gzVL2KqjU4xlVpsCxlT8bOXJI9/xCJT48r+3j3W+6oBUktQe5KocxiUCw36/ZVUdtyLcdY0=
Message-ID: <86802c440805192022n29e191dfped3ee5afa7894288@mail.gmail.com>
Date: Mon, 19 May 2008 20:22:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080520041655.0552236d@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080518014111.4f32298b@googlemail.com>
	 <20080518164127.2236d82a@googlemail.com>
	 <86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
	 <20080518232347.7964835c@snowcone>
	 <86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
	 <20080520014405.5eb150cd@googlemail.com>
	 <86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
	 <20080520022446.3b9c335a@googlemail.com>
	 <86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
	 <20080520041655.0552236d@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 8:16 PM, Ciaran McCreesh
<ciaran.mccreesh@googlemail.com> wrote:
> On Mon, 19 May 2008 19:48:38 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>> >> >> could be pci iomem conflicts...
>> >> >> please enable CONFIG_PCI_DEBUG=y
>> >> >> and apply the following two debug patches
>> >> >
>> >> > dmesg with debugging attached.
>> >>
>> >> the iomem allocation seems good...
>> >>
>> >> can you send out /proc/iomem?
>> >
>> > 00000000-0009ffff : pnp 00:09
>> > <snip>
>>
>> seems acpi pnp resource cause some problem....
>>
>> please try attached patch and send out /proc/mtrr
>
> The patch doesn't help I'm afraid.

sorry, please send /proc/iomem

after check request_resource and insert resource...

it seems if you insert or request one small one, and request big one,
then only have big one, but if you insert the big one, the small one
will because big one's child...

so at that case, could be pnp res return from acpi (dsdt) is bigger
than e820 region...

so it seems the offending patch just reveal problem cause by pnp code.

YH
