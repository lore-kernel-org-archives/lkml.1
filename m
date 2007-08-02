Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbXHBNHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbXHBNHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXHBNHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:07:25 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20650 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbXHBNHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:07:23 -0400
Message-ID: <46B1D708.9040106@msgid.tls.msk.ru>
Date: Thu, 02 Aug 2007 17:07:20 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Herbert Rosmanith <kernel@wildsau.enemy.org>, linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
References: <200708021056.l72Au722008603@wildsau.enemy.org> <Pine.LNX.4.64.0708021347270.24572@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708021347270.24572@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 2 2007 12:56, Herbert Rosmanith wrote:
>>> On Aug 2 2007 12:42, Herbert Rosmanith wrote:
>>> There never *were* days when eth0 remained eth0 across such changes.
>> but there *were* days when eth0 was eth0, if the kernel reports it as such.
>> now there is no eth0 at all. if I see an "eth0" from dmesg, I expect
>> it to be present.
> 
> Wait, you forget that something may change the name. That dmesg message
> from 1 second ago does not need to be valid anymore, just as anything
> else in this world.

That was my argument - there should be no way to *change* the name, but
to give an alias(es) - entirely different thing.

Yes, if a device is replugged during that one second, it's another
at least "instance" of that device - similar to 'ifindex' field in
interface description (not shown by ifconfig but shown by `ip link'),
or to usb endpoint numbers which gets incremented each time one
plug something in.

But as long as the device is connected, it should have the same
name - that's my key point.  You may change its aliases as you
wish, but not the "primary name".

[]
>> the problem with this device renaming in my case was that other software,
>> in particular dhcpcd, didnt get any lease, because (obviously?) dhcpcd
>> on the other hand _still_ seemed to look for eth0, and thus, after
>> booting, there was no network configured at all.
> 
> So blame your distro for not integrating udev correctly with dhcp-client.
> I can only speak for suse, where you define BOOTPROTO=dhcp for an
> interface. Then, on /etc/init.d/network, every interface that has a
> configuration file gets run, so you never see what ethX udev picked for
> the day, but things still work. That's good^TM.

Again, this is questionable - the integration part, right way to it,
that is.

If - recalling my "naming scheme" with kernel ethX (which may change each
boot or even at runtime, OR may not change at all if I don't replug
devices), and nicN which is based on particular device's MAC address, --
I configured dhcp to listen on eth0, I assume it's the first network
card found by the system, whatever it is.  In this case, if I replaced
the card (because previous one was faulty etc), it will continue to
work (provided no other renames was done) without renames done by
udev, and will break with current udev behaviour.  But if I configured
dhcp to listen on *this* NIC with *this* serial number and MAC address,
current udev behaviour is right - the system just assumes that this
particular card isn't here (yet?) and hence dhcp shouldn't run on it.

You see - we again have two names - "first interface found by kernel"
and "this particular card with this serial number", and both of them
are useful.

Partially this issue can be solved by - say - kudzu asking for a
name if it finds new hardware (we'll answer it with the name our
replaced card had) - but such behaviour is out of the question
because system startup scripts should not generally ask "random
questions".

/mjt
