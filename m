Return-Path: <linux-kernel-owner+w=401wt.eu-S1764246AbXJZRKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764246AbXJZRKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbXJZRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:10:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:19744 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbXJZRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Q2w3DC8vr81m6nrtbpujOiQtPISHjr/bWUTidiCYyzHVuICBTez4y7Dafm911n9wxpWoNdHYlWnr2wjXjVduofpbP4WwIYZYrHSaoCOflVgJTTopbT9KDcHSLh/oVi0R4QZXVxhJ6Ewvkvs97DtKqLdtUDnc2puE7pJ0jMR57R8=
Message-ID: <3ae72650710261010p195e2228h91c9cb11829c2a77@mail.gmail.com>
Date: Fri, 26 Oct 2007 19:10:38 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Cc: "Greg KH" <gregkh@suse.de>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <200710260957.15137.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710181401.50470.jbarnes@virtuousgeek.org>
	 <200710251653.19978.jbarnes@virtuousgeek.org>
	 <20071026045950.GA22920@suse.de>
	 <200710260957.15137.jbarnes@virtuousgeek.org>
X-Google-Sender-Auth: c370f32905f41f2a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Thursday, October 25, 2007 9:59 pm Greg KH wrote:
> > On Thu, Oct 25, 2007 at 04:53:18PM -0700, Jesse Barnes wrote:
> > > Ok, here's yet another version that uses the device model for the
> > > suspend/resume, rather than pci hooks.
> > >
> > > Greg, DRM desperately needs review of its device model usage, can
> > > you take a look at this patch and the current drm_sysfs.c code?
> > > Right now, we're mixing class_devices and regular devices (the
> > > latter seem to be required for suspend/resume to work correctly),
> > > but this seems wrong. Any ideas?  Should we just rip out the
> > > class_device stuff and create full-on DRM device nodes?
> >
> > The class_device stuff is already ripped out in the latest -mm trees
> > and I will be forwarding that change on for 2.6.25 after 2.6.24 is
> > out.  So yes, it should be taken away :)
> >
> > But converting from class_device to struct device does not mean you
> > use a "device node".  But you could if you want to :)
>
> Yeah, bad choice of words. :)
>
> To retain compatibility, we need to have directories under the DRM class
> dir (/sys/class/drm) for each card (e.g. card0) that contains a file
> describing which graphics driver is bound to the device.  For class
> devices, we could just add an attributes structure to the device.  Can
> we do the same with regular, non-class devices?

The conversion is already queued in Greg's tree, and in -mm:
http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver/drm-convert-from-class_device-to-device-in-drivers-char-drm.patch;h=f993183d1cb017f981cc2232d17930af40459bd8;hb=HEAD

/sys/class/drm will look the same as with the class_device's, only if
!CONFIG_SYSFS_DEPRECATED, there will be symlinks instead of
directories, otherwise the same pathes, like for all other (converted)
classes too.

Thanks,
Kay
