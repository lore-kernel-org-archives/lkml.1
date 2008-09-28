Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYI1MiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYI1MiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 08:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYI1MiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 08:38:13 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:52633 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYI1MiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 08:38:12 -0400
X-Originating-IP: [74.251.44.253]
Date: Sun, 28 Sep 2008 07:38:10 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Console not capturing call trace
Message-ID: <20080928073810.0ff15533@osprey.hogchain.net>
In-Reply-To: <19f34abd0809280514o70787d36ua03c44945dc9f6ee@mail.gmail.com>
References: <20080921104625.655f55df@osprey.hogchain.net>
	<19f34abd0809280514o70787d36ua03c44945dc9f6ee@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEV2dXOAgYNxSD+aemaal42A
 gIBqYV2UU07Ik5GXfoFMRTdbKiVwAAACbUlEQVQ4jXXTzWvbMBQAcG3EZsmt0Owc3pgNPo1oxNFt
 pQnEN3Wrs3UnkdXq5tOwIdq9Pci3gUqJexo55KC/cs9O/dHBRIiMfpb03rNE4v800jxIQRzsXPEP
 jDwndhNelo9/ngE/SFdKmZQnfOT0YSSlQBKLiJBDH6w9SPwlp5evpduDr9biQqkV8Rh7p4NRNSO1
 4BHhpjLpIK2gWksIgl0LPLCHoBIcX6dp2kGKMYnfGJnjIFungZeuHA6dhSvqLXrA1zJmVKayCu1w
 DKuGAU+WZRRCsLdBFXgLl2Sw3N2ZEJDAn3VwEV9FK12YUGW+yqlIWiD30U5rbSi2efGuhRfxEXRB
 8e+uJE/AL5z78xrqVg6aBHlMTj9V7x/RJOMGHHI11ItVUW+B0JakkGPcUsJNHuY7/ZA04X4xwQ/D
 3I0FGgaT8iFponoJ26F+sNbu51O7l7QHHtNTbxMc5o/W+kw0S31Ub5i+pQBq/hjYPVPbJ/ic/aoC
 pbTQtxlAvvnZgNod89Y4D2sFXpMHZWU1yHb6Ft+g2aTJY84iY2iY4ySGmWdvmxlDprHkCgd1yDRV
 bXVfFQiZjyuyaU5p1pZkTbXBbxRagAyU2rZfcH2tTQ7+FpNQ4Ofb7lxdFzTHDGqAvHdEv0cIezi2
 be+0vzdUqawaDSATHfB7itGiIfrQu2p8UQOOooHTh5lUPn6lva/qQrWwQpCUTv08hGe3dkU9KWmJ
 Z2EGpAeDFc3kN8oMNbNJ/AzMFERUhjmehB7ws6XBTTnfeOXT9T/C9dn4HEshpPWIjDvgi5Px2U0G
 Hl7dzaQHg8U4Xn6oa4g3vVnqLz3ribDLdyFmAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008 14:14:09 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On Sun, Sep 21, 2008 at 5:46 PM, Jay Cliburn
> <jacliburn@bellsouth.net> wrote:
> > I'm thinking this may be a userspace issue, but most users don't
> > hack network drivers and don't encounter kernel warnings and
> > oopses, and therefore aren't likely to encounter this, so I'm
> > bringing it to the kernel list (especially those who run Fedora)
> > for assistance/opinions.
> >
> > The problem:  I no longer get full module lists and call traces on
> > the console for a WARN_ON (for example).  I run Fedora 9 and its
> > current version of rsyslog-3.18.1-2.fc9.x86_64.  Reverting to
> > rsyslog-3.14.1-2.fc9.x86_64 or advancing to
> > rsyslog-3.21.3-3.fc10.x86_64 didn't seem to help.
> >
> > For test purposes I inserted a WARN_ON(1) statement in the atl1
> > driver, and dmesg shows the output just fine, but /var/log/messages
> > and my serial console both fail to show the module list and call
> > trace. (Evidence below.)
> >
> > One thing I can't figure out is where the "<8>" comes from in
> > the serial console output down at the bottom of this message.
> > Backstepping from warn_on_slowpath() to print_modules() in the
> > kernel code doesn't seem to show an <8> printed anywhere.  I've got
> > /proc/sys/kernel/printk set to 8 8 8 8, so maybe that's related?
> >
> > Has anyone else encountered this or know which rsyslogd knob to
> > tweak to enable the full modules list and call trace?  I've
> > verified the condition occurs with current git, 2.6.26.3, and
> > 2.6.25.16 kernels, so I think it's not a kernel problem.  It *used*
> > to work fine, but I can't remember when it stopped doing so.
> 
> Hi,
> 
> I'll try an answer since you've had no other replies.
> 
> You probably need to set up rsyslogd to log all kernel messages. For
> me, changing the /etc/rsyslog.conf like this does the trick (but
> beware of my linewrapping client):
> 
> --- rsyslog.conf.orig   2008-09-28 14:10:20.000000000 +0200
> +++ rsyslog.conf.new    2008-09-28 14:10:12.000000000 +0200
> @@ -36,7 +36,7 @@
> 
>  # Log anything (except mail) of level info or higher.
>  # Don't log private authentication messages!
> -*.info;mail.none;authpriv.none;cron.none                /var/log/messages
> +kern.*;*.info;mail.none;authpriv.none;cron.none
> /var/log/messages
> 
>  # The authpriv file has restricted access.
>  authpriv.*                                              /var/log/secure
> 
> 
> I.e., you just need to add "kern.*" in the line that controls logging
> to /var/log/messages. I hope this helps.

Thanks for replying Vegard.  The problem turned out to be that I
overwrote /proc/sys/kernel/printk with "8 8 8 8" instead of just using
"8 x x x," where x is the default value.
