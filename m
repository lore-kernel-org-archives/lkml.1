Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZC0MWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZC0MWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZC0MWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:22:15 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:56288 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZC0MWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <20081107.013833.147302570.davem@davemloft.net>
References: <1226018639.3189.15.camel@nga> <20081106.233557.193705310.davem@davemloft.net> 
	<ac3eb2510811070033m108d8ed5t499c20ee02b2618f@mail.gmail.com> 
	<20081107.013833.147302570.davem@davemloft.net>
Date: Fri, 27 Mar 2009 13:21:56 +0100
Message-ID: <ac3eb2510903270521i113df787u7ac5d842ece83740@mail.gmail.com>
Subject: Re: sparc: struct device - replace bus_id with dev_name(), 
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Miller <davem@davemloft.net>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 10:38, David Miller <davem@davemloft.net> wrote:
> From: "Kay Sievers" <kay.sievers@vrfy.org>

>> >> -     if (strlen(bus_id_name) >= BUS_ID_SIZE - 4) {
>> >> +     if (strlen(bus_id_name) >= 20 - 4) {

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

Hey David,
it took a while, but it happened now, so this issue is coming back. :)

The name size limit is gone, there is no BUS_ID_SIZE thing anymore in
the driver core. BUS_ID_SIZE should go away in the 2.6.30 timeframe.

Could you please convert/remove BUS_ID_SIZE value from:
  drivers/net/gianfar.h:	char	phy_bus_id[BUS_ID_SIZE];
  drivers/net/ucc_geth.h:	char phy_bus_id[BUS_ID_SIZE];
  drivers/net/pasemi_mac.h:	char	phy_id[BUS_ID_SIZE];
  include/linux/phy.h:#define MII_BUS_ID_SIZE	(BUS_ID_SIZE - 3)
  include/linux/phy.h:	char bus_id[BUS_ID_SIZE];

Or let me know how you want to convert it, so I can do it?

Thanks a lot,
Kay
