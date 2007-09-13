Return-Path: <linux-kernel-owner+w=401wt.eu-S1764725AbXIMFKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764725AbXIMFKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXIMFKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:10:37 -0400
Received: from main.gmane.org ([80.91.229.2]:43963 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbXIMFKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:10:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Date: Thu, 13 Sep 2007 01:58:03 -0300
Organization: http://u-br.net
Message-ID: <rjsmr4-rc8.ln1@tux.abusar.org>
References: <46C1BCC5.9090709@amd.com>
	<1189626560.5160.57.camel@gaivota>
	<d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	<d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 200-207-206-233.dsl.telesp.net.br
X-Newsreader: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
X-Face: "g*5eYHIY,3>,mjb*Ct*Nas)P6a$h'JGcnp371H.F=?]}zS6?v8,<jRw3BK3FHOG?nLkDqh9X-:Ib$K8^Te^}L]1&;"<9qSe0G4^Lx?2JjSc1-i|.l$BI;vG\O!vkgrC_`LS0j@f
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Well, I'd like to see Linus' opinion about this, because while
programmers keep discussing this, users are waiting forever... so if
Markus has a concrete and better solution, why don't use it?

	And as far as I know, Markus is the programmer who is most
interested in this code. I didn't see anybody else in the world doing
his work...

	And I always had a impression that if most of things could be
done in user space, than it will be better (for example, devfs -> udev).
Why do everything in kernel space? Lets put *less* code in the kernel,
not more code. And besides that, code in user space can be changed
easily. Code in kernel has to wait a long time for Linus to accept (*if*
he accepts).

	Linus could put an end to this discussion, since he will say
the final word.

On Thu, 13 Sep 2007 01:10:55 +0200
"Markus Rechberger" <mrechberger@gmail.com> wrote:

> Let's add the LKML to this.
> 
> On 9/13/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> > On 9/12/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > Markus,
> > >
> > > Em Ter, 2007-08-14 às 16:31 +0200, Markus Rechberger escreveu:
> > > > Following patch adds the possibility to implement tuner drivers in
> > > > userspace.
> > >
> > > As you asked me about userspace driver, at Linux Conf Europe, let me
> > > give you my feedback about it.
> > >
> > > On Linux, userspace-to-kernelspace APIs are meant to be forever. This
> > > means that, once a newer API is created, this should remain supported
> > > for all future versions. So, such APIs should be carefully analyzed and
> > > accepted by the community, before going to mainstream.
> > >
> >
> > The V4L and DVB API is stable at the moment because it's at a stage
> > which is sufficient for older devices but not sufficient for newer
> > devices anymore.
> > To support newer device it needs a change.
> >
> > > I don't see any technical reason why tuner drivers should be moved to
> > > userspace. Looking at xc3028 device, the driver is very simple and
> > > doesn't require any special treatment that it isn't possible to be done
> > > at kernel. There are already some implementations on kernelspace that
> > > works fine.
> > >
> >
> > As from my side to support the xceive driver properly it needs a
> > rewrite and a proper API description. Since it's not possible to
> > discuss any API changes I will work around at least for those devices
> > which I can support for.
> >
> > > On the other hand, a TV driver without a tuner is a broken driver. With
> > > parts of the driver being at userspace, this means to add undesired
> > > complexity at the drivers architecture, while not bringing any benefit.
> > >
> > > If you look at V4L history, the first drivers started at userspace,
> > > being migrated to kernelspace, where we have the proper scenario for
> > > managing those devices.
> > >
> > > Another aspect that should be analyzed is what is desired by the
> > > community:
> >
> > don't get me wrong but the existing community is rather small and
> > kicking off people who are interested in changing things.
> > I recently had a talk with someone and I've been told that I'm kicking
> > off people.
> > Guess why I kick off people? -> because they do not contribute in a
> > productive way which also means submitting patches. Optical useless
> > changes don't make any difference at the functionality in the end. And
> > my requirements are ignored constantly here.
> >
> > > kernelspace tuners or userspace tuners. Keeping support for
> > > both at long term doesn't seem reasonable. The Linux community should
> > > decide what is the better way. Currently, only you are pushing for
> > > userspace tuners, mainly due to non-technical reasons.
> >
> > read the project site and you will see the reasons.
> > http://mcentral.de/wiki/index.php/Userspace_tuner#Advantages
> > Another advantage is that I have cygwin based code here which I can
> > easily reuse with all that work I'm not going to reinvent the wheel
> > even for newer devices which I work on.
> >
> > > Almost all the
> > > other developers are comfortable with kernelspace tuners. So, creating
> > > an userspace interface just to make you happy is not the way we should
> > > go.
> > >
> >
> > I'm afraid of giving the people which are against what I submitted the
> > responsibility over the project. Initially there was an RFC which
> > didn't get commented either (well there was one useless comment, I
> > tried to discuss it on IRC before with the same guy) after I
> > implemented exactly what I proposed there I got the first non
> > technical comments - also keep in mind that working on something costs
> > alot of time and talking about something unknown is rather cheap.
> >
> > > A final aspect is that having an userspace driver for tuner will mean
> > > that the kernel driver will depend on an userspace counterpart in order
> > > to work. This will allow a vendor with bad intentions to release a
> > > partially broken userspace driver, with limited capabilities, and a
> > > closed source driver for full support. This model is likely to occur, if
> > > you take a look at the past. For example: ATI and Nvidia closed source
> > > drivers, several soft modem drivers, some network drivers, ...
> > >
> >
> > Please go forward and discuss the UIO driver with Greg Kroah Hartmann
> > and the fuse driver with the other people. If companies want to
> > release binary drivers they can easily use the existing code put it
> > into an RPM or DEB package and Ubuntu will pick it up.
> >
> > > With all those issues, I'm against to add an userspace interface for
> > > tuners.
> > >
> >
> > I'm against how the project works out at the moment and how it worked
> > out in history. Exactly this way will kick off companies to be
> > interested in future like Avermedia. A driver can easily be written
> > within a few weeks and I've been struggling with it for 2 years(!!!)
> > now just for nothing finally telling me that some guys want to steal
> > my code and move it to kernelspace although it would raise more
> > complications with upcoming and current devices which have even more
> > requirements.
> > I spent more time in rewriting and discussing everything than to get
> > any of those requirements done.
> > Look at the dvb hotplug patch which came from my side, also look at
> > device node locking where the Hauppauge guy submitted a patch which
> > doesn't work properly because of the spinning thread in the end. I
> > would take my considerations and requirements a bit more serious.
> >
> > Markus
> >
> 
> 


-- 
Linux 2.6.22: Holy Dancing Manatees, Batman!
http://www.lastfm.pt/user/danielfraga
http://u-br.net
Dream Theater - "Panic Attack" (Octavarium - 2005)

