Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbXILXLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbXILXLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbXILXK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:10:58 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:9267 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbXILXK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QAbhoAn0sZHrKBK9wXCSLwzdKkhZPTNDBJXQwrbtocL6Bbl/n3UeeJas9SdwWMrG3PS9MClotNXyJzkjl9/bOlXxUee8XhuQXHbUvwky7M+3aY4gTWdaqmOLEJEx+BsS2mNQG/Jb+ojo/AnE2hnY3/ePjDg3W9AzyJBjAl1Ihas=
Message-ID: <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
Date: Thu, 13 Sep 2007 01:10:55 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       video4linux-list@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let's add the LKML to this.

On 9/13/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 9/12/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > Markus,
> >
> > Em Ter, 2007-08-14 às 16:31 +0200, Markus Rechberger escreveu:
> > > Following patch adds the possibility to implement tuner drivers in
> > > userspace.
> >
> > As you asked me about userspace driver, at Linux Conf Europe, let me
> > give you my feedback about it.
> >
> > On Linux, userspace-to-kernelspace APIs are meant to be forever. This
> > means that, once a newer API is created, this should remain supported
> > for all future versions. So, such APIs should be carefully analyzed and
> > accepted by the community, before going to mainstream.
> >
>
> The V4L and DVB API is stable at the moment because it's at a stage
> which is sufficient for older devices but not sufficient for newer
> devices anymore.
> To support newer device it needs a change.
>
> > I don't see any technical reason why tuner drivers should be moved to
> > userspace. Looking at xc3028 device, the driver is very simple and
> > doesn't require any special treatment that it isn't possible to be done
> > at kernel. There are already some implementations on kernelspace that
> > works fine.
> >
>
> As from my side to support the xceive driver properly it needs a
> rewrite and a proper API description. Since it's not possible to
> discuss any API changes I will work around at least for those devices
> which I can support for.
>
> > On the other hand, a TV driver without a tuner is a broken driver. With
> > parts of the driver being at userspace, this means to add undesired
> > complexity at the drivers architecture, while not bringing any benefit.
> >
> > If you look at V4L history, the first drivers started at userspace,
> > being migrated to kernelspace, where we have the proper scenario for
> > managing those devices.
> >
> > Another aspect that should be analyzed is what is desired by the
> > community:
>
> don't get me wrong but the existing community is rather small and
> kicking off people who are interested in changing things.
> I recently had a talk with someone and I've been told that I'm kicking
> off people.
> Guess why I kick off people? -> because they do not contribute in a
> productive way which also means submitting patches. Optical useless
> changes don't make any difference at the functionality in the end. And
> my requirements are ignored constantly here.
>
> > kernelspace tuners or userspace tuners. Keeping support for
> > both at long term doesn't seem reasonable. The Linux community should
> > decide what is the better way. Currently, only you are pushing for
> > userspace tuners, mainly due to non-technical reasons.
>
> read the project site and you will see the reasons.
> http://mcentral.de/wiki/index.php/Userspace_tuner#Advantages
> Another advantage is that I have cygwin based code here which I can
> easily reuse with all that work I'm not going to reinvent the wheel
> even for newer devices which I work on.
>
> > Almost all the
> > other developers are comfortable with kernelspace tuners. So, creating
> > an userspace interface just to make you happy is not the way we should
> > go.
> >
>
> I'm afraid of giving the people which are against what I submitted the
> responsibility over the project. Initially there was an RFC which
> didn't get commented either (well there was one useless comment, I
> tried to discuss it on IRC before with the same guy) after I
> implemented exactly what I proposed there I got the first non
> technical comments - also keep in mind that working on something costs
> alot of time and talking about something unknown is rather cheap.
>
> > A final aspect is that having an userspace driver for tuner will mean
> > that the kernel driver will depend on an userspace counterpart in order
> > to work. This will allow a vendor with bad intentions to release a
> > partially broken userspace driver, with limited capabilities, and a
> > closed source driver for full support. This model is likely to occur, if
> > you take a look at the past. For example: ATI and Nvidia closed source
> > drivers, several soft modem drivers, some network drivers, ...
> >
>
> Please go forward and discuss the UIO driver with Greg Kroah Hartmann
> and the fuse driver with the other people. If companies want to
> release binary drivers they can easily use the existing code put it
> into an RPM or DEB package and Ubuntu will pick it up.
>
> > With all those issues, I'm against to add an userspace interface for
> > tuners.
> >
>
> I'm against how the project works out at the moment and how it worked
> out in history. Exactly this way will kick off companies to be
> interested in future like Avermedia. A driver can easily be written
> within a few weeks and I've been struggling with it for 2 years(!!!)
> now just for nothing finally telling me that some guys want to steal
> my code and move it to kernelspace although it would raise more
> complications with upcoming and current devices which have even more
> requirements.
> I spent more time in rewriting and discussing everything than to get
> any of those requirements done.
> Look at the dvb hotplug patch which came from my side, also look at
> device node locking where the Hauppauge guy submitted a patch which
> doesn't work properly because of the spinning thread in the end. I
> would take my considerations and requirements a bit more serious.
>
> Markus
>


-- 
Markus Rechberger
