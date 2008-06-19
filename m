Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYFSXqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYFSXqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 19:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYFSXqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 19:46:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYFSXqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 19:46:34 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Date: Fri, 20 Jun 2008 01:46:03 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "R.L. Horn" <lists@eastcheap.org>,
       Olivier Galibert <galibert@pobox.com>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <200806180215.45925.hpj@urpla.net> <20080618185534.5f969f63@lxorguk.ukuu.org.uk>
In-Reply-To: <20080618185534.5f969f63@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806200146.03805.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+S51yupdBQzONfVt5W5TEU3jyQ+pbOKue7n3+
 Np6EpiPBKKAe67MT+30zgloORCIPvjjRscDf7YJbGCEOBlw70q
 Ja4PfXzBIIsGOIAheZEoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 18. Juni 2008 schrieb Alan Cox:
> On Wed, 18 Jun 2008 02:15:45 +0200
>
> "Hans-Peter Jansen" <hpj@urpla.net> wrote:
> > Am Dienstag, 17. Juni 2008 schrieb Alan Cox:
> > > On Mon, 16 Jun 2008 23:22:54 -0500 (CDT)
> > >
> > > Ah ok I know what the bug is - it was fixed in 2.6.26-rc as follows
> > >
> > > +       /* Don't rewrite B0 */
> > > +       if (tty_termios_baud_rate(termios))
> > > +               tty_termios_encode_baud_rate(termios, baud, baud);
> > >  }
> >
> > Alan, could this issue lead to dysfunctional serial dcf77 receivers,
> > too? (and could you point my to the related git changeset?)
>
> I don't generally work via git so I don't offhand know the changeset id.
> I guess it could do. If its causing this many actual problem cases it
> might also want to go into stable.

Alan, I got to test this by applying the changeset (Olivier, many thanks 
for your valuable hint, I'm sure, I will reuse this knowledge soon), to 
the otherwise unchanged kernel, but unfortunately, it doesn't solve my 
issue.

A different patch must have changed the behavior/state of some RS232 lines  
in the 2.6.25 time frame, since the device still doesn't get any power at 
all. Hopefully I get round bisecting it this weekend, but any hints are 
greatly appreciated.

As another data point: using a usb <-> rs232 converter, the dcf device got 
back to life again. It still doesn't work in its entirety, but at least, 
some data arrives in ntpd. Expected is something similar to:
-#--#-#####-###--D--S124--2-p------p-----21-4-24-----8-- (incomplete)
but it reads:
###############RADMLS1248124P124812P1248121241248112481248P
thus, obviously it doesn't get any 0 values back (displayed as - above).

The setting of the serial interfaces was equivalent, but maybe the usb 
converter cannot handle the rather strange 50 baud setting properly.

~# stty -a < /dev/ttyUSB0 
speed 50 baud; rows 0; columns 0; line = 0;
intr = <undef>; quit = <undef>; erase = <undef>; kill = <undef>; eof = <undef>; eol = <undef>; eol2 = <undef>;
swtch = <undef>; start = <undef>; stop = <undef>; susp = <undef>; rprnt = <undef>; werase = <undef>; lnext = <undef>;
flush = <undef>; min = 1; time = 0;
-parenb -parodd cs8 -hupcl -cstopb cread clocal -crtscts
-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8
-opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
-isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt -echoctl -echoke

Pete
