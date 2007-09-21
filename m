Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbXIUNOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbXIUNOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbXIUNOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:14:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:33428 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXIUNOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YnH51r/JYNcstwzskdP9fAWHjY3qn9+Ll44n3W0JQOz+flS69xcGCp6EPuk1B8ayhlbv6qo8dmsx/SdTN1gbVlSWJqw4MBPa16aqsQQsoil4aujGmhaIRep99f5WU+h95FGXcTtJ2CE+5AJEYBDuUD8+XaCLjUwOzd9fzdUZuws=
Message-ID: <851fc09e0709210614q33cf3c81u1441fda17a66a6fd@mail.gmail.com>
Date: Fri, 21 Sep 2007 21:14:43 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Cc: linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       "Kexec Mailing List" <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, "Len Brown" <lenb@kernel.org>
In-Reply-To: <200709211409.25008.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	 <200709211157.28622.nigel@nigel.suspend2.net>
	 <m18x70ofp3.fsf@ebiederm.dsl.xmission.com>
	 <200709211409.25008.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, 21 September 2007 05:33, Eric W. Biederman wrote:
> > Nigel Cunningham <nigel@nigel.suspend2.net> writes:
> > >
> > > That's not true. Kexec will itself be an implementation, otherwise you'd end
> > > up with people screaming about no hibernation support.
> >
> > There needs to be an implementation of hibernation based on kexec with
> > return yes.
> >
> > > And it won't result in
> > > the complete removal of the existing hibernation code from the kernel. At the
> > > very least, it's going to want the kernel being hibernated to have an
> > > interface by which it can find out which pages need to be saved.
> >
> > That interface should be running kernel -> user space -> target kernel.
> > Not direct kernel to kernel.
> >
> > > I wouldn't
> > > be surprised if it also ends up with an interface in which the kernel being
> > > hibernated tells it what bdev/sectors in which to save the image as well
> > > (otherwise you're going to need a dedicated, otherwise untouched partition
> > > exclusively for the kexec'd kernel to use), or what network settings to use
> > > if it wants to try to save the image to a network storage device.
> >
> > initramfs.  We already seem to have that interface.  And distros
> > seems to do a pretty decent job of using it to configure systems.
> >
> > > On top of
> > > that, there are all the issues related to device reinitialisation and so on,
> >
> > Yes.
> >
> > > and it looks like there's greatly increased pain for users wanting to
> > > configure this new implementation.
> >
> > Not to be callous but that really is a user space and distro issue.
> >
> > > Kexec is by no means proven to be the panacea for all the issues.
> >
> > I agree.  I'm still not quite convinced it will do a satisfactory job.
> > But I think it does make sense to implement a general kexec with
> > return and see if that can reasonably be used for handling hibernation
> > issues.  If done cleanly and with care the implementation won't be
> > hibernation specific.
>
> Yes, and that's worth doing anyway, IMO.
>
> > Frankly this looks like the best way I can see to implement a general
> > mechanism for calling silly firmware/BIOS/EFI services after we
> > have a kernel up and running.  It's a little bit like allowing
> > X to call iopl(3) and do inb/outb directly.
> >
> > The configuration issues you raise pretty much exist for kexec on
> > panic, and they seem to be being resolved for that case in a
> > reasonable way.  I do agree that the current kexec+return effort seems
> > to be one of those unfortunate cases where we give every mechanism in
> > the kernel to do something in user space and then no one actually
> > implements the user space.  That doesn't do any one any good.
> >
> > For hibernation we don't have the absolute need to step outside of the
> > current kernel that we do in the kexec on panic approach.  However we
> > have this practical fight about mechanism and policy, and kexec with
> > return has this seductive allure that it appears to be the minimal
> > necessary mechanism in the kernel.
> >
> > No one has yet attacked the hard problem of coming up with separate
> > hibernate methods for drivers.
>
> Well, I've been playing a bit with that for some time, but it's not easy by any
> means.
>
> In short, I'm seeing some problems related to the handling of ACPI that seem to
> shatter the entire idea of having separate hibernate methods, at least as far
> as ACPI systems are concerned.

So sadly to hear this. Can you details it a little? Or a link?

Best Regards,
Huang Ying
