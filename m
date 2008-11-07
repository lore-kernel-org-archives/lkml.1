Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYKGJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYKGJ6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYKGJ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:58:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:60937 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYKGJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:58:12 -0500
Message-ID: <ac3eb2510811070158i40ea64adq93511426e5c86ab7@mail.gmail.com>
Date: Fri, 7 Nov 2008 10:58:09 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "David Miller" <davem@davemloft.net>
Subject: Re: sparc: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: wli@holomorphy.com, greg@kroah.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081107.013833.147302570.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226018639.3189.15.camel@nga>
	 <20081106.233557.193705310.davem@davemloft.net>
	 <ac3eb2510811070033m108d8ed5t499c20ee02b2618f@mail.gmail.com>
	 <20081107.013833.147302570.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 10:38, David Miller <davem@davemloft.net> wrote:
> From: "Kay Sievers" <kay.sievers@vrfy.org>
> Date: Fri, 7 Nov 2008 09:33:16 +0100
>
>> On Fri, Nov 7, 2008 at 08:35, David Miller <davem@davemloft.net> wrote:
>> > From: Kay Sievers <kay.sievers@vrfy.org>
>> > Date: Fri, 07 Nov 2008 01:43:59 +0100
>> >
>> >> --- a/arch/sparc64/kernel/vio.c
>> >> +++ b/arch/sparc64/kernel/vio.c
>> >> @@ -224,7 +224,7 @@ static struct vio_dev *vio_create_one(st
>> >>       if (!strcmp(type, "domain-services-port"))
>> >>               bus_id_name = "ds";
>> >>
>> >> -     if (strlen(bus_id_name) >= BUS_ID_SIZE - 4) {
>> >> +     if (strlen(bus_id_name) >= 20 - 4) {
>> >>               printk(KERN_ERR "VIO: bus_id_name [%s] is too long.\n",
>> >>                      bus_id_name);
>> >>               return NULL;
>> >>
>> >>
>> >
>> > But I don't like this.
>> >
>> > Could you please keep the macro around until everything is converted?
>> > Then you can remove the test entirely.
>> >
>> > Leaving it with just constants there is inviting confusion, no matter
>> > how short amount of time it will be there.
>>
>> I can add a SPARC_BUS_ID_SIZE, to that file, or in a sparc header, but
>> the core will not provide any such value, and have to, go to catch all
>> remaining occurrences across the tree. Where should I add it?
>
> You should keep BUS_ID_SIZE in the device.h header or wherever it is
> now.
>
> Then it's a simply grep to kill that off and all the references (and
> you have to systematically eliminate these no-longer-needed tests
> anyways) in one fell swoop.
>
> Otherwise someone will have to grep for "20" (!!) in order to do that
> cleanup.

Yeah, but the thing is, that _I_ don't want to remove any checks or
limits from subsystem code. While touching hundreds of files the last
days, there are several instances which could break if I remove any
limits. And most of the stuff I can not even compile.

I can let the BUS_ID_SIZE in the header, but I rather have the people
who understand the code to change the behavior.

Anyway, care to apply the first hunk, and skip the "20" part? I'll
remove the "20" part from the net/ patch too and resend it.

Thanks,
Kay
