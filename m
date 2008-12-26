Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYLZTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYLZTJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLZTJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:09:26 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:56362 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbYLZTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:09:25 -0500
X-Trace: 123468892/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.219/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.219
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.2 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkGABm7VElQLLDb/2dsb2JhbACBbIEwujdYjxqGRA
X-IronPort-AV: E=Sophos;i="4.36,285,1228089600"; 
   d="scan'208";a="123468892"
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a
 joystick
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <20081223085946.GA14302@anvil.corenet.prv>
References: <1229728542.1441.6.camel@localhost.localdomain>
	 <20081222150636.8dc20d61.akpm@linux-foundation.org>
	 <1229994455.22856.61.camel@brick>
	 <20081223085946.GA14302@anvil.corenet.prv>
Content-Type: text/plain
Date: Fri, 26 Dec 2008 19:08:39 +0000
Message-Id: <1230318519.12447.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-23 at 03:59 -0500, Dmitry Torokhov wrote:
> On Mon, Dec 22, 2008 at 05:07:35PM -0800, Harvey Harrison wrote:
> > On Mon, 2008-12-22 at 15:06 -0800, Andrew Morton wrote:
> > > On Fri, 19 Dec 2008 23:15:42 +0000
> > > Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> > > 
> > > > Not sure what happened with earlier submissions, so here is an up-to-date
> > > > patch for the Dreamcast Maple controlled.
> > > > 
> > > > 
> > > > Add support for the SEGA Dreamcast Maple controller as a joystick
> > > > 
> > > > ...
> > > >
> > > > +static void dc_pad_callback(struct mapleq *mq)
> > > > +{
> > > > +	unsigned short buttons;
> > > > +	struct maple_device *mapledev = mq->dev;
> > > > +	struct dc_pad *pad = maple_get_drvdata(mapledev);
> > > > +	struct input_dev *dev = pad->dev;
> > > > +	unsigned char *res = mq->recvbuf;
> > > > +
> > > > +	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
> > > 
> > > hm, could that be simplified?
> > 
> > And as a bonus fix the obvious sparse warning:
> > 
> > 	buttons = ~le16_to_cpup((__le16 *)(res + 8));
> > 
> 
> Below is what I woudl like to apply unless you see more issues with the
> patch. Andrew, if you could test it on your hardware to make sure it
> still works that woudl be great.
> 
> Thanks!
> 

Just to say I've tested this with jstest now and it seems to be in good
working order. There is a calibration issue on one axis, but I think
that's my hardware :-)

