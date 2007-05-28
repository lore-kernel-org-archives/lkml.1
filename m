Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbXE1Drh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbXE1Drh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 23:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbXE1Dr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 23:47:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35977 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbXE1Dr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 23:47:26 -0400
Date: Mon, 28 May 2007 09:16:40 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Chris Newport <crn@netunix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-ID: <20070528034640.GA6367@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com> <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org> <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com> <20070525123456.GA17238@elte.hu> <20070525093354.5dbe5f43.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525093354.5dbe5f43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 09:33:54AM -0700, Andrew Morton wrote:
> On Fri, 25 May 2007 14:34:56 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Chris Newport <crn@netunix.com> wrote:
> > 
> > > There is a fundamental problem in getting a decent log to debug a 
> > > crashed kernel.  Maybe we should take a hint from Solaris. If the 
> > > kernel crashes Solaris dumps core to swap and sets a flag. At the next 
> > > boot this image is copied to /var/adm/crashdump where it is preserved 
> > > for future debugging. Obviously swap needs to be larger than core, but 
> > > this is usually the case.
> > 
> > we've got kdump, but it's not usually enabled by default by distros.
> 
> Isn't that awful?
> 

I think kdump should be enabled by default. Or at least user should be
given an option to enable/configure this service at installation time.

Things are still good atleast in RHEL5. It gives user a option to
enable/disable kdump at firstboot after installation. A fall side of
doing it at firstboot time is that a user has to go for an extra reboot
if he chooses to enable kdump (Because of kernel command line crashkernel=).
An improvemnt could be that these options should be given at installation
time so that a user does not have to go through an extra reboot to enable
kdump service. 

It also has got graphical scripts to configure kdump serivce and enable it.
Other distributions are catching up but there seems to be a reluctance
to enable kdump by default primarily because of a chunk of memory being
reserved for kdump kernel which can not be used by regular kernel.

As of today RHEL reserves 128MB of memory for x86/x86_64 arch if kdump
is enabled. Some people are also reluctant to change the installer to
include a screen which can help user enable/disable/configure kdump. They
think it increases installer complexity and user is likely to get confused.

> By now we should be in the situation where if a tester is hitting a
> kernel crash we can say to them "please turn on crashdumps and send me
> the image".  But we're not - kernel developers don't know how to turn the
> thing on in $RANDOM_DISTRO, testers have no experience with the feature
> and kernel developers don't have experience handling the crash images.
> 
> And I'm not sure that the (required) "don't dump user memory and pagecache"
> feature has been implemented yet?
> 

Yes. It has been implemented and integrated with RHEL5. Not sure about others.
NEC developers have developed a user space filtering utility which can filter
out pagecache, user memory and zero pages.

http://sourceforge.net/projects/makedumpfile

In RHEL5, one can pre-configure filtering options and a filtered crash
dump will automatically be saved to user configured destination.
 
Thanks
Vivek

