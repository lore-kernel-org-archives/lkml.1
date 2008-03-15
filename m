Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYCORfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYCORfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 13:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYCORf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 13:35:29 -0400
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:34815 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751990AbYCORf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 13:35:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Sat, 15 Mar 2008 10:35:23 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       Bryce Harrington <bryce@bryceharrington.org>
References: <47D828BB.2000702@gawab.com> <200803141029.38124.jbarnes@virtuousgeek.org> <47DB46F1.80106@gawab.com>
In-Reply-To: <47DB46F1.80106@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151035.23808.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Bryce to cc list, he may have a copy of intel_reg_dumper already built 
for Ubuntu.  Bryce, please see below for a few more questions, thanks.]

On Friday, March 14, 2008 8:48 pm Justin Madru wrote:
> Jesse Barnes wrote:
> > It would be interesting if you could get register dumps at a couple of
> > different points, using the intel_reg_dumper tool in
> > git://git.freedesktop.org/git/xorg/driver/xf86-video-intel (in
> > src/reg_dumper).
>
> I couldn't get it to compile. What am I suppose to do? I ran autogen.sh
> in the top level dir and it gave the error message:
>
> ./configure: line 20486: syntax error near unexpected token `XINERMA,'
> ./configure: line 20486: `XORG_DRIVER_CHECK_EXT(XINERMA, xineramaproto)'

This usually means you don't have the xorg autoconf macros installed.  Your 
distro probably has some sort of xserver-devel package that may include it.

> Then I also tried to run make and make -f Makefile.in (in the reg_dumper
> dir and top level dir), and it said:
>
> Makefile.in:15 *** missing separator. Stop.
>
> That part of Makefile.in contains:
> @SET_MAKE@
> VPATH = @srcdir@
>
> What am I doing wrong? You'll have to forgive me, I'm not that
> experienced with the cmd line and compiling - I'm trying though.

No problem, building X still isn't quite as easy as it should be, but it's 
only slightly more complicated than the typical './configure;make;make 
install' due to the dependencies between packages.  You can check out the X 
wiki (wiki.x.org), there are some hints on building things there.

> > You'll probably have to modify your boot scripts though.
> > It would be good to get them:
> >   - at startup time before the splash screen
> >   - sometime while the splash screen is running
> >   - after X starts and you see the blank screen
>
> How exactly would I do that? I would think I could just add command at
> the end of 3 files in /etc/init.d. Would that work? It should run my
> command when it starts that script and gets to the end. Or do boot
> scripts exit in the middle of the script, which would prevent my command
> from running?

Hm, I haven't looked at the Ubuntu scripts before.  I know they're using 
upstart, but if they haven't divered too much from the old style init, you 
may be able to modify rc.sysinit to get the boot time register dump.

For the splash screen dump, you'd just have to add the intel_reg_dumper 
command to one of the other init scripts that runs while the splash screen is 
up (maybe the HAL daemon script or something).

Once your screen is blank, it's probably easiest to ssh into your machine and 
capture the dump that way.

Hope that helps, maybe Bryce can give you some more hints on Ubuntu specifics.

> > What's different between your Uni. environment and your home environment?
>
> I'm not sure. I just have a home wireless router (Hawking HWR54G). I
> have no idea what the Uni. router is.
> On both, I connect to an unencrypted network, but at the Uni. it
> redirects to a login page where I have to log on before I can actually
> use the Internet. Is there anyway I could get more information about the
> Uni. router?

Probably, though the messages in your log from your Univ. connection may be 
enough for the networking guys to figure things out.  It's probably best to 
track the wireless thing as a separate issue though, I'd recommend mailing 
linux-wireless@vger.kernel.org with the problem.

Thanks,
Jesse


