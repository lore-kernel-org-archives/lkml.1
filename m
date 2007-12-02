Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbXLBSp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbXLBSp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXLBSpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:45:51 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:60413 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXLBSpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:45:50 -0500
Date: Sun, 2 Dec 2007 20:45:44 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Dan Kegel <dank@kegel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Relax permissions for reading hard drive serial number?
Message-ID: <20071202184544.GK6372@mea-ext.zmailer.org>
References: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com> <1196350632.20567.191.camel@skunk.anacadf.mentorg.com> <a71bd89a0711290746q57002217ga14c4f4f7201683d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a71bd89a0711290746q57002217ga14c4f4f7201683d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 07:46:19AM -0800, Dan Kegel wrote:
> On Nov 29, 2007 7:37 AM, Xavier Bestel <xavier.bestel@free.fr> wrote:
> > > One sticking point is that apps like Photoshop and probably
> > > Punkbuster want to retrieve the hard drive's serial number
> >
> > So they can't be installed on a network drive ?
> 
> I think Adobe supports that, though perhaps not with the
> retail version.  Big companies with network drives are
> probably an important revenue source for them.
> 
> I haven't looked closely at what happens when you try installing
> onto network drives.  If you are really interested, it's pretty easy to
> try yourself; just run the app under wine with
> WINEDEBUG=+cdrom,+disk and look in the log for calls like
> CreateFile("\\\\.\\PhysicalDrive0", ...).
> There's some chance the code always checks drive 0 instead
> of the drive you're installing onto.

This lack of having stable(*) unique system identifier available to
applications is one of the small details that make node locked
commercial software delivery challenging thing in UNIX environments..

*) "stable" as both stable data, and stable API to get it.

There is always the way of delivering such one with a physical serial
number device, but for purely selfish reasons I do compare _same_
software delivered for Windows and for Linux -- the Windows version
is available for free in a certain very usefull subset, while Linux
version costs a few thousand dollars, and is still less functional
than the free Windows subset.

One UNIX software licensor has resolved this in a way that prevents
successfull restore of the license file - possibly by storing stat(2)
st_ino data in the license data.  Forcing the license file to have
any specific i-node number on UNIX filesystems is - a bit difficult.

Simple-ish solution here is, of course, to run part of the software
via a suid-root helper binary, which then accesses system serial
number informations - and does some other usefull and necessary
functionality, like find and open external USB device(s) that the
software suite drives - by passing opened device handle to the caller
program (**).   Software installation would want to run in super-user
mode to create directory for software data ( /opt/XYZ/ ) and to
install the helper binaries, of course.

**) I am thinking of hardware programmer tools which highly likely
do not have drivers per se in Linux kernel, nor are they easy to
configure for hotplug to be assigned (device chowned) to any specific
user.  Such suid-root tool would let non-privileged user to access
the device.


One fairly stable thing in UNIX systems are network card MAC addresses.
That data is available without super-user privileges, and even the
API to retrieve it has been stable for about whole time that Linux
has had network services.  One can reset the device MAC address, so
it isn't as stable as license lockers would want to -- nor difficult
to fake.  It has one nasty feature, tough: If you have same MAC on
multiple machines within same LAN, your network will all the sudden
work rather poorly.

Nevertheless it is *unique* data that is available to anybody wanting
to pick it up, thus I do think that it is hypocritical of making
all manners of other identifiers unavailable.

Now that I mentioned this, most paranoid of you would of course
want to make MAC address to be "privileged data", and thus change
existing API.  Before you do that, check how IPv6 does its address
assignments, and what would it mean to system if programs can't
find out its own inbound nor outbound IPv6 addresses on connected
sockets ? ( -> getsockname() )



> - Dan

/Matti Aarnio
