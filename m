Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXCHQvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXCHQvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXCHQvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:51:36 -0500
Received: from khc.piap.pl ([195.187.100.11]:39350 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXCHQvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:51:35 -0500
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, Oleksiy Kebkal <kebkal@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	<200703071019.55896.rgetz@blackfin.uclinux.org>
	<57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com>
	<200703080844.32157.rgetz@blackfin.uclinux.org>
	<20070308134800.GA30023@flint.arm.linux.org.uk>
	<45F01AA8.7010608@gmx.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 08 Mar 2007 17:51:28 +0100
In-Reply-To: <45F01AA8.7010608@gmx.net> (Carl-Daniel Hailfinger's message of "Thu, 08 Mar 2007 15:16:08 +0100")
Message-ID: <m3r6rz3chb.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net> writes:

> Unless you want two machines to monitor each other via serial console and
> each of them has only one serial port. It's not perfect, but it works well
> enough despite all claims to the contrary.

Sure, if you don't need "input" (only "console logger" function and
not "initial input/output terminal"). It has nothing to do with the
RTS "problem", though.

BTW: reasonably working, standard-compliant USB-RS232 converters
cost $15 or so. Unfortunately not that all machines have USB ports.

I agree with Russell - mixing kernel console and application's
port is asking for trouble.

OTOH I wonder what does the device in question require WRT the
serial port and WRT RTS line in particular.
I know there are some half-duplex converters which drive RTS only
while sending and which require CTS to send. They are perhaps a bit
broken and require some CSMA-alike retransmissions etc.

I don't know if one can expect RTS to stay low all the time. Even
a simple /sbin/setserial from /etc/rc.* would drive it high for
a moment. I'm afraid the only way which makes sense may be using
a customized plug.
-- 
Krzysztof Halasa
