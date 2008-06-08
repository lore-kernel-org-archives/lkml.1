Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYFHBCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYFHBCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 21:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYFHBCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 21:02:13 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:52376 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755300AbYFHBCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 21:02:12 -0400
Date: Sat, 7 Jun 2008 22:02:07 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: "John W. Linville" <linville@tuxdriver.com>,
       Ivo van Doorn <IvDoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080608010207.GA11086@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <20080606162324.GB635@tuxdriver.com> <20080607005227.GA1739@ime.usp.br> <20080607143051.GA3096@tuxdriver.com> <20080608001143.GB10775@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080608001143.GB10775@ime.usp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, John.

I'm including Ivo van Doorn in this e-mail. I hope that the
problem gets solved soon.

On Jun 07 2008, Rogério Brito wrote:
> Hi, again, John.
> 
> On Jun 07 2008, John W. Linville wrote:
> > On Fri, Jun 06, 2008 at 09:52:27PM -0300, Rog?rio Brito wrote:
> > > I have taken dmesg "snapshots" of my system together with many other
> > > information regarding how it is configured and I put it at my
> > > homepage, at <http://www.ime.usp.br/debug/>.
> > 
> > 404
> 
> I think that you should have received a later reply telling about the typo
> in the address above. It should have been:
> <http://www.ime.usp.br/~rbrito/debug/>.

This time I hope that I have not done anything incorrectly.

> > > >From what I am seeing, it looks like the bug mentioned in
> > > <http://bugzilla.kernel.org/show_bug.cgi?id=9388>, but I don't get the
> > > stack trace that is present there and I'm just trying to use WEP
> > > instead of WPA or anything fancier.
> > 
> > Did you apply this patch?
> > 
> > 	http://bugzilla.kernel.org/attachment.cgi?id=14384
> 
> No, I did not. Is it still relevant with -rc4 or with -rc5? I still get the
> same problem with -rc5 (but I will have to test it a bit more with -rc5).

Unfortunately, this patch won't even apply with 2.6.26-rc5 as the code
seems to have changed a lot between that date and today. For instance,
there doesn't seem to exist a function called "rt2500usb_config_mac_addr"
in the rt2x00 directory (just did a grep on my unconnected iBook).

I hope that this helps Ivo to understand what the issue is:

> Just as a refresher:
> 
> * I can set everything on the iBook with the wireless key plugged;
> * The wireless key *sees* the AP, even with encryption (that is, it grabs
>   the MAC address of the AP, it (sometimes) shows me the signal strength,
>   and if I issue "iwconfig wlan0 ap any", I see both the led of the
>   wireless key blink and an increase of amount of data transmitted and
>   received with "ifconfig wlan0");
> * With everything set this way, if I do "dhclient wlan0", it doesn't get a
>   lease from the AP---actually, despite the fact that it is possible to see
>   the other point, dhclient goes, after some attempts of getting a lease,
>   to background, but no address is ever gotten;
> * Just to rule out possible problems with something sent to the address
>   255.255.255.255 (which is reported as being done by dhclient), I tried to
>   configure the address by hand via ifconfig, but, for instance, I couldn't
>   ping my AP (which I can from other computers with a rt61pci driver and a
>   PCMCIA connection);
> * As I mentioned above, I have no problems with the rt61pci driver, but the
>   USB one doesn't seem to work (unfortunately, the iBook does not have a
>   PCMCIA slot). With a notebook with an on-board Intel wireless card, I
>   *also* don't have any problems.
> 
> Well, thanks, for the help so far. I hope that we can solve this issue
> quite soon, as I need this iBook for work.
> 
> I am willing to help as much as I can and test anything (even something
> that might be "experimental"). I think that this is as good a tester that
> you can get, right? :-)

Again, I am willing to test any "intrusive" change as I still don't have
valuable data on that machine. BTW, I have firmware from Debian's
ralink-firmware package (which should be what ralink has released)
installed on this machine.

I don't know if the firmware is needed in my case or not, though (my USB
adaptor is a D-Link DWL-G122 H/W Ver. B1, F/W Ver.: 2.03---took that info
from the back of the stick).

Oh, I should mention that MacOS X is able to use the card without any
problems on this machine and with encryption. (I may have forgotten to say
that before). And, just to rule out things, I can test this USB adaptor on
a ia32 notebook running Ubuntu's Hardy Heron, but I don't know how much
patched their kernel is.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
