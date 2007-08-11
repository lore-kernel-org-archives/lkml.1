Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbXHKN0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbXHKN0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 09:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXHKN0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 09:26:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:20995 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXHKN0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 09:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=C30fqbYO+l7nlgemk5ffz9faB7Lmh7JfdB93SzJ1Zc0NAcXMh8/+Lg2D6AWrp3PZ3wcLRZJeM83vWCHNfV4w23kvDJzSStg7QtsIcS+yQwnlMgyjEbNt2angowaE0gCApJk5P1+KsJ+XQNo2322sM2tQJc7dMVZOGoUY32Vwcjg=
Message-ID: <3ae72650708110626r79341890w67ce030edaa32f98@mail.gmail.com>
Date: Sat, 11 Aug 2007 15:26:03 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Javier Pello" <javier.pello@urjc.es>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not notified
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       GregKH <greg@kroah.com>
In-Reply-To: <46BCD7AA.5080407@urjc.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B37CF7.2020803@urjc.es> <46B7832B.6010808@urjc.es>
	 <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	 <1186491472.3611.33.camel@lov.localdomain>
	 <20070807162618.3814ff78@gondolin.boeblingen.de.ibm.com>
	 <46BAE005.4000906@urjc.es> <1186660716.21247.94.camel@lov.localdomain>
	 <46BCD7AA.5080407@urjc.es>
X-Google-Sender-Auth: 07e98a4cffea737d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/07, Javier Pello <javier.pello@urjc.es> wrote:
> On Thu 09 Aug 2007, Kay Sievers wrote:
>
> > On Thu, 2007-08-09 at 11:36 +0200, Javier Pello wrote:
> >
> > > Anyway, my point is that it is useless to have the kernel block for
> > > a minute at boot waiting for something that cannot happen, and that
> > > it should be avoided (even if my proposed solution is not the way
> > > to go).
> >
> > That's true. And it sounds all reasonable from your point of view,
> > and the firmware loader needs fixing, and the silly blocking request
> > needs to be removed from the kernel, that's known for a very long
> > time now, but nobody did the work so far.
>
> If I see it correctly, your point is that the firmware loader is
> totally broken and needs replacing. That's fine, and I won't say
> otherwise. But it doesn't seem that such replacement is under way
> and, in the meanwhile, we are stuck with what we have. I'm not
> defending the current loader but, while we have it, we might as
> well not have it freeze the whole kernel for a minute waiting
> for something that won't happen.
>
> > But in this specific case, it is more the combination of your
> > options, what causes this problem to appear. You don't have an
> > initramfs, you don't use modules, but you are linking a driver
> > into the kernel image which depends on a conceptually broken
> > blocking userspace transaction to initialize.
> > This combination of options just doesn't make sense. Either
> > use initramfs, or use a kernel module for the driver that needs
> > userspace to initialize, or patch the driver not to block in
> > the request, or patch the driver to optionally include the
> > firmware in the driver.
>
> Note that the problem is not getting the driver to work---I can
> do that pretty easily. The problem is that there's a number of
> drivers that, just because they require firmware, will hang the
> kernel on boot if built in unless an initramfs is carefully
> prepared. An allyesconfig kernel could freeze for 10 minutes
> during boot just because it came across 10 devices requiring
> firmware, even if you don't intend to use them.
>
> > You just picked a set of options that doesn't work nicely
> > together.
>
> I agree. That's why I sent the patch, to make it work better.
>
> > No distro setup has this problem, that's probably why nobody
> > really cared and it didn't get fixed so far.
>
> I agree again. But the fact that it didn't get fixed so far
> doesn't mean that it can never get fixed, does it?
>
> Also, note that I'm not proposing massive changes, or changes
> that will break things for other people (not intentionally,
> anyway), or that will add complexity and unmaintainability
> to the kernel. They try to do a reasonable thing and are
> small and to the point.

Sure, but all these problems don't happen, if you don't include an
"incomplete" driver in the kernel image.
What I want to say is that it seems obvious to me to compile a driver,
which depends on a userspace transaction, as a module. Even with your
changes, compiling it in still depends on a weird userspace rebinding
hack to make it work, which doesn't solve the problem at a generic
level, where it should be fixed instead.

Thanks,
Kay
