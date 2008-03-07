Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYCGIod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYCGIod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYCGIoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:44:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3984 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752080AbYCGIoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:44:21 -0500
Date: Fri, 7 Mar 2008 09:42:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Greg KH <greg@kroah.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 0/9] Devices accessibility control group (v4)
Message-ID: <20080307084245.GA5004@ucw.cz>
References: <47CED717.60406@openvz.org> <20080306015513.GA5359@kroah.com> <20080306031525.GA9070@sergelap.austin.ibm.com> <20080306043427.GA15498@kroah.com> <47CFAD06.7020501@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CFAD06.7020501@openvz.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-06 11:36:22, Pavel Emelyanov wrote:
> Greg KH wrote:
> > On Wed, Mar 05, 2008 at 09:15:25PM -0600, Serge E. Hallyn wrote:
> >> Quoting Greg KH (greg@kroah.com):
> >>> On Wed, Mar 05, 2008 at 08:23:35PM +0300, Pavel Emelyanov wrote:
> >>>> Changes from v3:
> >>>> * Ported on 2.6.25-rc3-mm1;
> >>>> * Re-splitted into smaller pieces;
> >>>> * Added more comments to tricky places.
> >>>>
> >>>> This controller allows to tune the devices accessibility by tasks,
> >>>> i.e. grant full access for /dev/null, /dev/zero etc, grant read-only
> >>>> access to IDE devices and completely hide SCSI disks.
> >>>  From within the kernel itself?  The kernel should not be keeping track
> >>> of the mode of devices, that's what the filesystem holding /dev is for.
> >>> Those modes change all the time depending on the device plugged in, and
> >>> the user using the "console".  Why should the kernel need to worry about
> >>> any of this?
> >> These are distinct from the permissions on device files.  No matter what
> >> the permissions on the device files, a task in a devcg cgroup which
> >> isn't allowed write to chardev 4:64 will not be able to write to
> >> /dev/ttyS0.
> > 
> > Then why not do that from userspace with a different /dev, or with a
> > LSM?
> 
> Different dev is not suitable, since task may still call mknod to
> create device it needs and use it. This is not about comfortable
> use, this is about security.

And you may still take out mknod capability...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
