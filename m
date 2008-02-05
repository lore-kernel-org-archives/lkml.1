Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYBECBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYBECBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 21:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYBECBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 21:01:42 -0500
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:33283 "HELO
	web31811.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753261AbYBECBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 21:01:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=ecDDIGo5oZ4pW0ov/oF/6xQgYFtYqI/mdd4ZI1pN+yg/Iaf8qMVExa1w2uzx3To5/Y7FMCLOV6IxY+/2DjMnVJEjPwsgVf79gFU2nSu1gu7lUjiGWx+8DFEYcMQGvkrhFDCa66SirfEsSKa3i/w67QDdsbHzhf6p/m7oR3Abf9I=;
X-YMail-OSG: exxh3W4VM1kQbJyVJ9cwgNkgfNNQkHblAY8FmZDS.Sgcv3ftjePTchFCowIOODo1BETkww--
X-Mailer: YahooMailWebService/0.7.162
Date: Mon, 4 Feb 2008 18:01:36 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] enclosure: add support for enclosure services
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
In-Reply-To: <1202172065.3096.154.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <922945.25870.qm@web31811.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 2/4/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > The enclosure misc device is really just a
> library providing
> > > sysfs
> > > support for physical enclosure devices and their
> > > components.
> > 
> > Who is the target audience/user of those facilities?
> > a) The kernel itself needing to read/write SES pages?
> 
> That depends on the enclosure integration, but right at the
> moment, it
> doesn't

Yes, I didn't suspect so.

> 
> > b) A user space application using sysfs to read/write
> >    SES pages?
> 
> Not an application so much as a user.  The idea of sysfs is
> to allow
> users to get and set the information in addition to
> applications.

Exactly the same argument stands for a user-space
application with a user-space library.

This is the classical case of where it is better to
do this in user-space as opposed to the kernel.

The kernel provides capability to access the SES
device.  The user space application and library
provide interpretation and control.  Thus if the
enclosure were upgraded, one doesn't need to
upgrade their kernel in order to utilize the new
capabilities of the SES device.  Plus upgrading
a user-space application is a lot easier than
the kernel (and no reboot necessary).

Consider another thing: vendors would really like
unprecedented access to the SES device in the enclosure
so as your ses/enclosure code keeps state it would
get out of sync when vendor user-space enclosure
applications access (and modify) the SES device's
pages.

You can test this yourself: submit a patch
that removes SES /dev/sgX support; advertise your
ses/class solution and watch the fun.

> > At the moment SES device management is done via
> > an application (user-space) and a user-space library
> > used by the application and /dev/sgX to send SCSI
> > commands to the SES device.
> 
> I must have missed that when I was looking for
> implementations; what's
> the URL?

I'm not aware of any GPLed ones.  That doesn't
necessarily mean that the best course of action is
to bloat the kernel.  You can move your ses/enclosure
stuff to a user space application library
and thus start a GPLed one.

> But, if we have non-scsi enclosures to integrate, that
> makes it harder
> for a user application because it has to know all the
> implementations.

So does the kernel.  And as I pointed out above, it
is a lot easier to upgrade a user-space application and
library than it is to upgrade a new kernel and having
to reboot the computer to run the new kernel.

> A sysfs framework on the other hand is a universal known
> thing for the
> user applications.

So would a user-space ses library, a la libses.so.

> > One could have a very good argument to not bloat
> > the kernel with this but leave it to a user-space
> > application and a library to do all this and
> > communicate with the SES device via the kernel's
> /dev/sgX.
> 
> The same thing goes for other esoteric SCSI infrastructure
> pieces like
> cd changers.  On the whole, given that ATA is asking for
> enclosure
> management in kernel, it makes sense to consolidate the
> infrastructure
> and a ses ULD is a very good test bed.

What is wrong with exporting the SES device as /dev/sgX
and having a user-space application and library to
do all this?

    Luben

