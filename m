Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYKGJis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYKGJis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYKGJif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:38:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42997
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754770AbYKGJie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:38:34 -0500
Date: Fri, 07 Nov 2008 01:38:33 -0800 (PST)
Message-Id: <20081107.013833.147302570.davem@davemloft.net>
To: kay.sievers@vrfy.org
Cc: wli@holomorphy.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: sparc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: David Miller <davem@davemloft.net>
In-Reply-To: <ac3eb2510811070033m108d8ed5t499c20ee02b2618f@mail.gmail.com>
References: <1226018639.3189.15.camel@nga>
	<20081106.233557.193705310.davem@davemloft.net>
	<ac3eb2510811070033m108d8ed5t499c20ee02b2618f@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kay Sievers" <kay.sievers@vrfy.org>
Date: Fri, 7 Nov 2008 09:33:16 +0100

> On Fri, Nov 7, 2008 at 08:35, David Miller <davem@davemloft.net> wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Date: Fri, 07 Nov 2008 01:43:59 +0100
> >
> >> --- a/arch/sparc64/kernel/vio.c
> >> +++ b/arch/sparc64/kernel/vio.c
> >> @@ -224,7 +224,7 @@ static struct vio_dev *vio_create_one(st
> >>       if (!strcmp(type, "domain-services-port"))
> >>               bus_id_name = "ds";
> >>
> >> -     if (strlen(bus_id_name) >= BUS_ID_SIZE - 4) {
> >> +     if (strlen(bus_id_name) >= 20 - 4) {
> >>               printk(KERN_ERR "VIO: bus_id_name [%s] is too long.\n",
> >>                      bus_id_name);
> >>               return NULL;
> >>
> >>
> >
> > But I don't like this.
> >
> > Could you please keep the macro around until everything is converted?
> > Then you can remove the test entirely.
> >
> > Leaving it with just constants there is inviting confusion, no matter
> > how short amount of time it will be there.
> 
> I can add a SPARC_BUS_ID_SIZE, to that file, or in a sparc header, but
> the core will not provide any such value, and have to, go to catch all
> remaining occurrences across the tree. Where should I add it?

You should keep BUS_ID_SIZE in the device.h header or wherever it is
now.

Then it's a simply grep to kill that off and all the references (and
you have to systematically eliminate these no-longer-needed tests
anyways) in one fell swoop.

Otherwise someone will have to grep for "20" (!!) in order to do that
cleanup.
