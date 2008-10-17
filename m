Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYJQIQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYJQIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYJQIQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:16:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:20233 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYJQIQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:16:40 -0400
Message-ID: <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com>
Date: Fri, 17 Oct 2008 01:16:38 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [RFC] Kernel version numbering scheme change
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081017075544.GB4850@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081016002509.GA25868@kroah.com>
	 <20081016124943.GE23630@cs181140183.pp.htv.fi>
	 <20081016151748.GA31075@kroah.com>
	 <20081016164602.GA22554@cs181140183.pp.htv.fi>
	 <20081017034717.GA28188@kroah.com>
	 <20081017064751.GE22554@cs181140183.pp.htv.fi>
	 <20081017075544.GB4850@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 12:55 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 17, 2008 at 09:47:51AM +0300, Adrian Bunk wrote:
>> On Thu, Oct 16, 2008 at 08:47:17PM -0700, Greg KH wrote:
>> > On Thu, Oct 16, 2008 at 07:46:02PM +0300, Adrian Bunk wrote:
>> > > On Thu, Oct 16, 2008 at 08:17:48AM -0700, Greg KH wrote:
>> > > > On Thu, Oct 16, 2008 at 03:49:43PM +0300, Adrian Bunk wrote:
>> > > >...
>> > > > > If a distribution will try to autobuild an urgent OpenSSL security
>> > > > > update for their stable release in a chroot on a machine running
>> > > > > kernel 2009.2.3 they will surely love you for being responsible
>> > > > > for this...
>> > > >
>> > > > Distros properly patch things and backport "urgent OpenSSL security
>> > > > updates" to older versions of packages, so they would not run into this
>> > > > problem.
>> > >
>> > > You didn't get my point.
>> > >
>> > > Let me make an example:
>> > >
>> > > The current Debian release will be supported until one year after the
>> > > next release gets released.
>> > >
>> > > Someone from the Debian security team send a fixed package to the
>> > > buildds.
>> > >
>> > > The buildds build packages in chroots.
>> > >
>> > > A buildd may run any Debian release.
>> > >
>> > > And it's perfectly normal that a buildd runs a more recent release of
>> > > Debian than the one a package gets built for in a chroot.
>> >
>> > So you are saying the Debian build system would build a package for an
>> > older release, on a system that is newer,
>>
>> Packages are built in a chroot with the correct release installed.
>
> Then why would this break if they are being built against the correct,
> older, kernel?
>
>> > and that build would be
>> > determining things based on the system it is built on, not what it is
>> > being built for?
>>
>> No.
>>
>> In the example I gave it is OpenSSL that parses the version number of
>> the kernel.
>
> The running kernel, with the expectation that this is the kernel it is
> going to be running on after it is built, right?  Sounds like to ensure
> this is correct, you better be building it on the kernel that you are
> going to run it on, or its build process is broken.
>
>> > If so, then something is very broken already in the Debian build system
>> > and I think you have much bigger problems to worry about right now.
>> >
>> > For all other "sane" build systems that I know of, you build against the
>> > libraries/kernel/gcc/glibc/etc that you are wanting to support it for,
>> > not against some random-whatever-happened-to-be-installed-on-the-box.
>>
>> Building in a chroot is hardly "very broken".
>>
>> And it does build against the correct
>> libraries/kernel headers/gcc/glibc/etc .
>
> But not against the proper kernel it will be run on, which sounds
> broken.
>
>> Did you ever use a chroot?
>
> There's a fine line between being condencending and asking a valid
> question.  I'll assume you are not being condencending here...
>
> Yes, of course.
>
>> And this was just one example.
>>
>> What does userspace with the kernel version returned by GDTIOCTL_OSVERS?
>
> I don't know, hopefully not much if anything.  glibc does things with
> it, but that is usually to turn off emulation of various features that
> are in the kernel in newer releases.
>
>> I don't know whether it just displays the number, or whether it
>> determines anything based on it.
>>
>> Or what else might parse the version number?
>>
>> What if some proprietary userspace software like Skype or Flash or
>> whatever parses the kernel version number at runtime and barfs on
>> 2009.2.3 in a way similar to the OpenSSL build system?
>>
>> WHAT YOU SUGGEST WILL BREAK EXISTING USERSPACE SOFTWARE.
>>
>> Please admit this fact.
>
> "Might" I will give you, "Will", I will not without actually testing.
>
> And hey, if it's a problem, just fix userspace reporting to always say
> we are the 2.6.30 release and go on our merry way, perhaps providing
> another sysctl if it's really needed (glibc probably wants it, so it
> would be easy to add.)
>
> That's just a minor technical thing that can be trivially fixed _IF_ we
> decide it is something that we want to do.
>
> And to get back to the original point, Linus had expressed such an
> interest in changing this a while ago, so I was bringing it up, saying
> that I to thought we should change this, and proposed one such naming
> change.
>
> That has nothing to do with the "OMG You killed SKYPE!" hysteria that
> you are proposing here.  Please separate the two issues as they are
> totally different.
>
> thanks,
>
> greg "take a chill pill" k-h

I believe some of Adrian's concerns are valid. Userspace programs will
indeed break, largely because some depend on build-time and run-time
checks for the kernel version being >=2.6.0 or >=2.4.0 and so forth. I
suspect the best way to prove userspace breakage would be to make a
branch of the kernel with a new versioning scheme (8.10, 2008.10,
whatever) and use that as the installed kernel while building a Gentoo
system. I suspect you'd see massive breakage.

I think a version numbering system change would be OK (though I
wouldn't very much -like- it), so long as there was a way for
userspace software to be able to differentiate between a kernel with
the old versioning system and the new versioning system.

I think perhaps a better option in the long run is to start a v2.7
tree and figure out some Cool New Stuff(tm) to implement, keeping
consistency with the current versioning scheme.

- Steven
