Return-Path: <linux-kernel-owner+w=401wt.eu-S1763487AbYEOVUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487AbYEOVUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYEOVUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:20:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbYEOVUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:20:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Date: Thu, 15 May 2008 23:20:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
References: <Pine.LNX.4.44L0.0803221645190.27399-100000@netrider.rowland.org> <200805150147.24968.rjw@sisk.pl> <m1fxsjp9ry.fsf@frodo.ebiederm.org>
In-Reply-To: <m1fxsjp9ry.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805152320.14016.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 of May 2008, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Thursday, 15 of May 2008, Eric W. Biederman wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >> Just an added data partial point.  In the kexec case I have had not heard
> >> anyone screaming to me that ACPI doesn't work after we switch kernels.
> >
> > You don't remove power from devices while doing that.
> 
> No.  It is the second half of S5.  When we go from the boot kernel
> to the restored kernel I am talking about.

Well, you don't remove the power from devices doing that, do you?

I was referring to the fact that you remove the power from devices after saving
the image (ie. in the "poweroff" stage).  Then, you initialize them and pass
all that to the restored kernel and the question here is:
(a) Should they be reinitialized before the restored kernel has a chance to
    access them?
(b) If they should, what state they ought to be in when the restored kernel
    accesses them.

That basically depends on how you're going to handle the resuming of devices,
especially on the ACPI bus, in the restored kernel.

If we are to follow ACPI, the answer to (a) is "no", except for devices used to
read the image and it's better if the boot kernel doesn't touch ACPI at all.
Then, the benefit of putting the system into S4 during the "poweroff" stage is
that (a) the resume can be carried out faster and (b) the restored kernel may
use some context preserved by the platform over the sleep state.

Also, that allows you to use the wake up capabilities of some devices that
need not be available from S5.

In any case, however, I don't really think that doing the kexec jump before
creating the image is really necessary.  The kexec jump during resume is in
fact very similar to what the current hibernation code does, but it's slightly
more complicated. :-)

Thanks,
Rafael
