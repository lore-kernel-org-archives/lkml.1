Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZETXmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZETXmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZETXmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:42:46 -0400
Received: from mail108.messagelabs.com ([216.82.250.51]:42638 "EHLO
	mail108.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZETXmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:42:45 -0400
X-VirusChecked: Checked
X-Env-Sender: tanderson@curtisswright.com
X-Msg-Ref: server-6.tower-108.messagelabs.com!1242862965!65302426!1
X-StarScan-Version: 6.0.0; banners=curtisswright.com,-,-
X-Originating-IP: [63.111.32.72]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: RapidIO - general questions
Date: Wed, 20 May 2009 16:42:41 -0700
Message-ID: <DB9BF8E7D974314CA8FEF8445DE4098F047F3EB4@SDGEXCH01.SDG.CW.LOCAL>
In-Reply-To: <1242802800.9160.143.camel@demuxf9c>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RapidIO - general questions
Thread-Index: AcnZGMNBdJ5kt9VsQGCqF8okRDZBDgAirSsA
References: <1242119872.16400.113.camel@demuxf9c><2a27d3730905130357re0adf41l19f5603a70dac57b@mail.gmail.com><1242372791.26759.34.camel@demuxf9c><2a27d3730905150056m7298b66ckb9db92f9432953d6@mail.gmail.com> <1242802800.9160.143.camel@demuxf9c>
From: "Anderson, Trevor" <tanderson@curtisswright.com>
To: "Jan Neskudla" <jan.neskudla.ext@nsn.com>,
       "ext Li Yang" <leoli@freescale.com>
Cc: "linuxppc-dev" <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With regards to your Oops: we sometimes find that, although a switch may
report a port being active, whenever
we try to discover what lies behind it, transfer errors occur that are
non-recoverable.

As a solution, on Freescale MPC8641D, we use a DMA transfer to perform a
simple MAINT read on a new device, just to see if it responds. Transfer
errors may still happen, but they are recoverable in that case, and you
can train your code to avoid that port or try it later. (The DMA engine
will report the error, not the processor.)



> -----Original Message-----
> From: linuxppc-dev-bounces+tanderson=curtisswright.com@ozlabs.org
[mailto:linuxppc-dev-
> bounces+tanderson=curtisswright.com@ozlabs.org] On Behalf Of Jan
Neskudla
> Sent: Wednesday, May 20, 2009 12:00 AM
> To: ext Li Yang
> Cc: linuxppc-dev; linux-kernel@vger.kernel.org
> Subject: Re: RapidIO - general questions
> 
> n Fri, 2009-05-15 at 15:56 +0800, ext Li Yang wrote:
> > On Fri, May 15, 2009 at 3:33 PM, Jan Neskudla
<jan.neskudla.ext@nsn.com> wrote:
> > > On Wed, 2009-05-13 at 18:57 +0800, ext Li Yang wrote:
> > >> cc'ed LKML
> > >>
> > >> On Tue, May 12, 2009 at 5:17 PM, Jan Neskudla
<jan.neskudla.ext@nsn.com> wrote:
> > >> > Hallo
> > >> >
> > >> > we'd likes to use a RapidIO as a general communication bus on
our new
> > >> > product, and so I have some questions about general design of
Linux RIO
> > >> > subsystem. I did not find any better mailing list for RapidIO
> > >> > discussion.
> > >> >
> > >> > [1] - we'd like to implement following features
> > >> >    * Hot-plug (hot-insert/hot-remove) of devices
> > >> >    * Error handling (port-write packets - configuration,
handling of
> > >> > them)
> > >> >    * Static ID configuration based on port numbers
> > >> >    * Aux driver - basic driver, for sending messages over
different
> > >> > mboxes, handling ranges of doorbells
> > >> >
> > >> >    Is it here anyone who is working on any improvement, or
anyone who
> > >> > knows the development plans for RapidIO subsystem?
> > >> >
> > >>
> > >> AFAIK, there is no one currently working on these features for
Linux.
> > >> It will be good if you can add these useful features.
> > > Yes it looks like that, currently we are analyzing current rapidIO
> > > system, and how we can add these features.
> > >
> > >>
> > >> > [2] - I have a following problem with a current implementation
of
> > >> > loading drivers. The driver probe-function call is based on
comparison
> > >> > of VendorID (VID) and DeviceID (DID) only. Thus if I have 3
devices with
> > >> > same DID and VID connected to the same network (bus), the
driver is
> > >> > loaded 3times, instead only once for the actual device Master
port.
> > >>
> > >> This should be the correct way as you actually have 3 instances
of the device.
> > >>
> > >> >
> > >> > Rionet driver solved this by enabling to call initialization
function
> > >> > just once, and it expect that this is the Master port.
> > >>
> > >> Rionet is kind of special.  It's not working like a simple device
> > >> driver, but more like a customized protocol stack to support
multiple
> > >> ethernet over rio links.
> > >>
> > >> >
> > >> > Is it this correct behavior  ? It looks to me that RapidIO is
handled
> > >> > like a local bus (like PCI)
> > >>
> > >> This is correct behavior.  All of them are using Linux
device/driver
> > >> infrastructure, but rionet is a special device.
> > >
> > > But I do not have a 3 devices on one silicon. I am talking about 3
> > > devices (3 x EP8548 boards + IDT switch) connected over rapidIO
through
> > > the switch. And in this case I'd like to have only one driver
siting on
> > > the top of Linux RapidIO subsystem. I don't see the advantage of
loading
> >
> > You are having one driver, but it probes 3 times for each device
using
> > the driver.
> >
> > > a driver locally for remote device. Am I missing something  ?
> >
> > If you want to interact with the remote device, you need the driver
to
> > do the work locally.
> 
> We are going to use a RapidIO as a bigger network of active devices,
and
> each will have each own driver (sitting on its own), and all the
> settings will be done over maintenance packets.
> 
> May be it will be solved by the fact, that we are going to use a
> staticIDs, so there will be no discovery as it is now. And thus there
> will be only one device visible in the internal structures of the
> subsystem, and thus only one drive will be loaded.
> 
> >
> > >
> > > And one more think, I am getting so much Bus errors OOPSes.
Whenever
> > > there is a problem with a comunication over Rio I get such a
kernel OPS.
> > > I had to add some delays into some function to be able to finish
the
> > > enum+discovery process. Did you have some experience with some
bigger
> > > rio network running under linux ?
> >
> > It looks like an known issue for switched rio network, but I don't
> > have the correct equipment to reproduce the problem here.  Could you
> > do some basic debugging and share your findings?  Thanks.
> 
> I tried to acquired some info about the problem, I found that the OOPS
> always occur when there is no respond from the device or the respond
is
> too slow. I always got that error during function call
> rio_get_host_deviceid_lock when it tries to access a remote device or
> switch. This function is the first call of the
rio_mport_read_config_32
> so is also first try of remote access to any device.
> 
> It is a timing issue, and after placing a printk into the
> rio_get_host_deviceid_lock the OOPSing almost disappeared.
> 
>                                  Jan
> 
> >
> > - Leo
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

_______________________________________________________________________
This e-mail and any files transmitted with it are proprietary and intended solely for the use of the individual or entity to whom they are addressed. If you have reason to believe that you have received this e-mail in error, please notify the sender and destroy this email and any attached files. Please note that any views or opinions presented in this e-mail are solely those of the author and do not necessarily represent those of the Curtiss-Wright Corporation or any of its subsidiaries.  Documents attached hereto may contain technology subject to government export regulations. Recipient is solely responsible for ensuring that any re-export, transfer or disclosure of this information is in accordance with applicable government export regulations.  The recipient should check this e-mail and any attachments for the presence of viruses. Curtiss-Wright Corporation and its subsidiaries accept no liability for any damage caused by any virus transmitted by this e-mail.
