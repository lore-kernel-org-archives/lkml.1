Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYGOI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYGOI23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYGOI2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:28:21 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:9610 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbYGOI2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:28:19 -0400
Date: Tue, 15 Jul 2008 10:28:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org, "Hans de Goede" <j.w.r.degoede@hhs.nl>,
       "Samuel Ortiz" <samuel@sortiz.org>, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org, "David Hubbard" <david.c.hubbard@gmail.com>
Subject: Re: [RFC] (almost) booting allyesconfig -- please don't poke
 super-io without request_region
Message-ID: <20080715102802.6b7e1efe@hyperion.delvare>
In-Reply-To: <88f5162604470179b3c6ebfe729a46f5@bga.com>
References: <for-27-patch1-0@bga.com>
	<48768018.2070704@hhs.nl>
	<acca8e14e769b2feadee19f1f7448438@bga.com>
	<20080711085246.1ead773b@hyperion.delvare>
	<48770B5E.7000308@hhs.nl>
	<20080711093650.4b98e3b7@hyperion.delvare>
	<4879A144.8060203@hhs.nl>
	<4dfa50520807131411ied883cgcb20eb6bd94f761@mail.gmail.com>
	<487A7211.7030309@hhs.nl>
	<4dfa50520807131426t4013142cp1fcd49e078a79c1f@mail.gmail.com>
	<20080714095914.0644ac5d@hyperion.delvare>
	<88f5162604470179b3c6ebfe729a46f5@bga.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milton,

On Mon, 14 Jul 2008 12:09:03 -0500, Milton Miller wrote:
> On Jul 14, 2008, at 2:59 AM, Jean Delvare wrote:
> > Well, there are two approaches to the problem. The first approach
> > (which I think Jim took in his patches? I don't really remember) is to
> > simply solve the problem of concurrent I/O access to the Super-I/O
> > configuration ports (typically 0x2e/0x2f or 0x4e/0x4f). That would be a
> > simple driver requesting the ports in question and exporting an API for
> > other drivers to access them in a safe way.
> >
> > The second approach is to make it a whole subsystem, as David is
> > suggesting. The Super-I/O driver would then not only request the I/O
> > ports, it would also identify which Super-I/O is there, and it would
> > create devices (in the Linux device driver model sense of the term) for
> > every logical device we are interested in (amongst which the hwmon
> > ones.) The hwmon drivers would have to be converted from platform
> > drivers to superio drivers.
> >
> > Each approach has its advantages. The first one is rather simple and
> > also very generic in nature. It could be reused for other purposes. The
> > second one offers automatic loading of hwmon drivers, which would be
> > nice to have.
> >
> > There's probably a middle way which would keep the simplicity of the
> > first approach while still allowing for driver auto-loading, without
> > changing the bus type of all drivers. It would probably take some
> > research though.
> 
> I haven't done the research, but it might be keep superio as
> a platform driver, and keep the clients as platform drivers.  Only
> have the superio driver probe and discover the subcomponent
> addresses and then create the platform devices as children
> instead of having each driver create its own platform device.
> (This all assumes they are all platform devices in sysfs, I have
> not looked).
> 
> This is all because in the platform bus the bus driver does not
> discover the addresses but relies on drivers or platform setup code.

That's more or less what I had in mind, yes.

> > (...) Milton, will you write a patch?
> 
> Well, that is the second time you asked me, so I guess I should respond.
> 
> While I it is possible for me to write this patch, my schedule and
> priority list predict it would not be before the merge window closes.  
> In fact, I'm not sure when it would come out.  It might be argued it
> could go in early -rc, but I would fear somebody's chip will not be detected
> with the additional check.  For example, the port may reserved as mother
> board resources or something.

I really don't see this as something for kernel 2.6.27, it's too late
already. It doesn't fix any actual problem anyway (none that can be
fixed by not loading drivers you don't need, at least.) That would be
for 2.6.28, so we have plenty of time to test the changes and ensure
they do not break anything. As you are the one who reported the issue
as something that was bothering you personally, I expected you to also
spend some time trying to address it.

> (...) Also, I have no hardware to test any
> proposed patch, so it would be compile check only.

If you write the patches and post them to the lm-sensors list, I am
certain that you will find several volunteers for testing. Me, I can
offer testing of the it87, f71805f and w83627ehf drivers.

Thanks,
-- 
Jean Delvare
