Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbZE0CiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbZE0CiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbZE0CiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:38:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZE0CiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:38:03 -0400
Date: Tue, 26 May 2009 22:38:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to
  mount debugfs filesystem.
In-Reply-To: <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905262231210.27902@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>  <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com>  <20090526205414.GA26016@kroah.com>  <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>
 <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1268308244-1243391884=:27902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1268308244-1243391884=:27902
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE




On Wed, 27 May 2009, GeunSik Lim wrote:

> On Wed, May 27, 2009 at 6:15 AM, Steven Rostedt <rostedt@goodmis.org> wro=
te:
> >
> > On Tue, 26 May 2009, Greg KH wrote:
> >> >
> >> > The filesystem Nazi's out there will argue that the proper place to =
mount
> >> > the debugfs filesystem is /sys/kernel/debug. I personally find that
> >> > location annoying.
> >>
> >> Why?
> >
> > Because it is too much to type ;-)
> I think so. But, when we consider many developers that use linux kernel
> source all over the world, I think that a regular rules or consistency
> is important
> as greg k-h explained.
>=20
> Recently, I read "ftrace-world.odp" presentation file  of steven rostedt.
>=20
> For example, about Mounting debugfs...
> #> mount -t debugfs nodev /sys/kernel/debug
> OR
> #> mkdir /debug
> #> mount -t debugfs nodev /debug
>=20
> I want that we will reach a consensus about mount directory name of
> debugfs filesystem to avoid confusing among the kernel developers.
>=20
> /debug/ ?
> or   /sys/kernel/debug/?
>  .....
>=20
> Frankly speaking, I like /sys/kernel/debug/ rule is better than /debug/ r=
ule
> for consistency.

And this is why I always mention that directory.

>=20
> >
> >>
> >> When I created debugfs, I was told that I had to pick a place to mount
> >> it so that everyone could write scripts that "knew" where it would be.
> >>
> >> So we picked /sys/kernel/debug/ and the code creates the mount point t=
o
> >> put it there. =C2=A0Now distros actually mount debugfs at that locatio=
n.
> >>
> >> So, now you don't like this? =C2=A0After it's become a standard? =C2=
=A0Ick.
> >>
> >> Becides, /debug/ is pretty presumptious, it's as if debugging the kern=
el
> >> is a system-wide thing :)
> >>
> >> So please, don't use /debug/ use the standard, defined, and ACTUALLY
> >> USED BY DISTROS TODAY mount point of /sys/kernel/debug/
> >>
> >> If you want to create your own symlink from /debug/ to that location t=
o
> >> make it easier to type, feel free, but do not hard code any scripts to
> >> use that location, or they are going to break.
> >
> > All my scripts search /proc/mounts to find where debugfs is mounted, th=
en
> > it uses that.
> >
> > Hmm, Not sure what packages in the distros use the default. I don't see
> > the debugfs in /etc/fstab in any of my machines.
> >
> Yes.. In my case, I use linux distributions like Ubuntu 8.10, Fedora
> 9/10, CENTOS 5.3 currently. This distributions  use proc , tmpfs,
> devpts, sysfs for official release
> by default.
>=20

The key thing is not to have scripts depend on a path. When debugfs is=20
enabled in a kernel, you automatically get /sys/kernel/debug, so that is a=
=20
natural place to mount it.

I have also suggested to people (as Greg suggested earlier to me) that you=
=20
can mount it there and then make a soft link to it. Which also works.

I personally just mount it at /debug.

To handle the scripts problem, all my scripts start with:

# grep debugfs /proc/mounts | cut -d ' ' -f 2

I also have a C function to do a search for debugfs in /proc/mounts.

If you look in Documentation/trace/ftrace.txt I have:

=3D=3D=3D
To mount the debugfs system:

  # mkdir /debug
  # mount -t debugfs nodev /debug

( Note: it is more common to mount at /sys/kernel/debug, but for
  simplicity this document will use /debug)
=3D=3D=3D

Thus it is a personal preference of mine to put it at /debug. But I do not=
=20
hide the fact that it is recommended to be in /sys/kernel/debug. Heck, I'm=
=20
the one that brought to light that path in this thread. I just curse it=20
everytime I have to say it ;-)

-- Steve

--8323328-1268308244-1243391884=:27902--
