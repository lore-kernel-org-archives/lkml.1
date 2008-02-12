Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYBLQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYBLQDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYBLQDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:03:04 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:9854 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYBLQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:03:01 -0500
In-Reply-To: <20080207221712.GC19310@kroah.com>
References: <20080108163305.GB10026@in.ibm.com> <20080128182423.GC28861@kroah.com> <20080128192204.GO14201@localdomain> <200801291112.41337.ossthema@de.ibm.com> <20080129132309.GA10898@kroah.com> <OFB2A9433F.35E00CA4-ONC12573DF.0049FB58-C12573DF.005988BA@de.ibm.com> <20080207221712.GC19310@kroah.com>
Subject: Re: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
To: Greg KH <greg@kroah.com>
Cc: akpm@linux-foundation.org, Jan-Bernd Themann <THEMANN@de.ibm.com>,
       Joachim Fenkes <FENKES@de.ibm.com>, linux-kernel@vger.kernel.org,
       Nathan Lynch <ntl@pobox.com>, ossthema@linux.vnet.ibm.com,
       sam@ravnborg.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OFA9F595D1.7CA72F19-ONC12573ED.00541641-C12573ED.00550432@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Tue, 12 Feb 2008 16:28:33 +0100
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 12/02/2008 17:02:58
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH <greg@kroah.com> wrote on 07.02.2008 23:17:12:

> On Tue, Jan 29, 2008 at 03:20:20PM +0100, Christoph Raisch wrote:
> What is it?  It has to live on some kind of bus, right?

It is a piece of hardware with a firmware/hypervisor abstraction layer on
top.
The hypervisor provides virtualization interfaces to
add and remove ethernet adapters and ports.
Each port is represented in the open firmware device tree (OFDT) as a
subnode of the
ehea adapter node.

System P has a userspace DLPAR application communicating with firmware, the
kernel, and
the hardware management console to change all that on the flight.
This tool needs a capability to identify which open firmware device tree
entry
belongs to which ethernet device.
Each node created by the ibmebus driver has a devspec entry associated to
the
device node in OFDT, used by the DLPAR application.
Each port created by the ibmebus driver has a devspec entry associated to
the
port node in OFDT, used by the DLPAR application.

> >
> > host:/ # ls -l /sys/bus/pci/devices/0000\:c8\:01.0/
> > total 0
...
> > -r--r--r-- 1 root root   4096 2008-01-29 14:26 devspec
...

> >
> > These pci functions corresponds to a
> > /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port0
> > and
> > /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port1
> >
> > The busdriver currently does not find out, how many ports are in a
> > /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1.
> > This is up to the hardware specific driver responsible for ehea or
ehca.
> > Think of a PCI card where the PCI busdriver
> > can not determine how many ports are implemented on the card.
> >
> > How should this be mapped to /sys ?
> >
> > Should we try to "flatten" the ports to something like
> > /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1
> > /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1_port0
> > /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1_port1
> > ...which means physical hierarchy information would look a bit strange,
> > but could be the simpler one.
>
> No.  Why have a separate "port" device for every ethernet port?  What
> keeps you from just creating the different network devices for your
> device, and pointing the parent to the same 789D.001.XXXXXX-P1 device?
>
>
> I think you all are trying to make this more complex than it really is
> :)

If you register multiple netdevs in a ehea adapter node,
how is it possible to find out which ethXXX belongs to which devspec port
entry in the OFDT?

Is there a simpler way than the one we chose to get this in addition?

>
> thanks,
>
> greg k-h
Gruss / Regards
Christoph Raisch


