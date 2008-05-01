Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbYEAVVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbYEAVVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYEAVVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:21:00 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:56969 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYEAVU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:20:59 -0400
Date: Thu, 1 May 2008 14:16:06 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: lkml <linux-kernel@vger.kernel.org>, Ben Nizette <bn@niasdigital.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
In-Reply-To: <200804302135.56529.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0805011249500.18441@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net> <200804301908.32346.david-b@pacbell.net>
 <Pine.LNX.4.64.0804301931030.1537@t2.domain.actdsltmp>
 <200804302135.56529.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, David Brownell wrote:
> On Wednesday 30 April 2008, Trent Piepho wrote:
>>>>>    /sys/class/gpio
>>>>>    	...
>>>>
>>>> "simple"?  What I had was a lot simpler.
>>>
>>> But it had some "must fix" problems, which I told you when you
>>> posted your first patch.  You didn't fix them.  And since then,
>>> your pushback seems to rely very heavily on ignoring issues I
>>> pointed out are "must fix" or "can't/doesn't work that way".
>>
>> So what are these must fix problems?
>
> Not fixed in any update you sent to your original patch, in
> the past three weeks, that's the key point.  In particular,

Let's be fair about who was waiting for who.  You didn't like some things
about my original system, I proposed changes here,
http://article.gmane.org/gmane.linux.kernel/662862, on April 7th.  You didn't
respond until April 27th, then decided to take my patch and change it they way
you wanted, ignoring what I wrote it accomplish, the very next day.

> the number one issue was completely ignored.  (Your recent
> responses haven't come across to me as helpful either..)

And this issue is?

>> You say nothing in sysfs works this way, but I don't agree.  Take a look at
>> /sys/class/net, you have names like "tap0", "eth0", "eth1", "lo", etc.  This
>> is exactly what I'm saying to do.  The first "eth" gpio chip you register is
>> appears as eth0 in sysfs, the second as eth1, and so on.
>
> So, when I said that sysfs doesn't use names like "gpio-19" but instead
> uses names like "gpio19" ... exactly what don't you agree with?

Instead of gpio19, it should be the chip label followed by 19.  I want "eth0",
"tap0".  You want "net0", "net1", and then a whole extra system to figure out
what's eth and what's tap.

>> You say your system works for everything that matters
>> and just dismiss the problems I'm solving as irrelevant with a wave of your
>> hand.  That's very convenient for you, but where does it leave me?
>
> Those are *NOT* my words.  Again, I don't know what straw man you

 	"However, I think a slightly more common practice in current embedded
 	Linux systems is to build custom kernels that know which
 	daughtercard(s) are available.  That's mostly what gets pushed
 	upstream, anyway..."

 	"Which is why this particular side-argument seems like a waste of time
 	to me:"

 	"Which isn't exactly where most folk start."

>> Your worried about the memory usage of some extra sysfs files, but include
>> python on your device?  IMHO, if you can't do this simple task in 5 minutes
>> with just busybox, the system is making things too hard.
>
> Right, and since I *can* do stuff like that in busybox with ASH,
> that quickly, I hope you'll agree your flamage has been blowing
> things way out of proportion here.

It's so easy, yet no one posts the code to do it.

>
>
>> What is the reason to not have the label with gpio in sysfs?
>
> Elaborated in my reply to Ben; see that.

 	because for a pure userspace interace it can't be helpful unless
 	userspace makes the labels:

I just don't see that.  I've got a JTAG interface on the gpio pins.  The user
wants to see what gpio pin is assigned to what function.  The information
could be right there with the direction and value.  They could have a script
that searches the gpios for one with a matching label.

I've got a board revision that so far the kernel doesn't care about.  I
could put something like this in my init scripts:
for i in 0 1 2 3
do
    echo "Board Rev [bit $i]" > /sys/class/gpio/pca9557-1:$i/label
done

Yes, I could only have the information in some docs and force someone to look
it up every time.  But the gpios can have labels, so why not use them?

>> How does seeing the value, direction, and label of a gpio "muck around with
>> its internal state?"
>
> Userspace being able to MODIFY the direction and output value
> is most certainly mucking around!!!

Now you're the one with the straw-man.  I've proposed many times that gpios
that have been requested by anything be exported READ-ONLY automatically.  I
said "*seeing* the value", not "*changing* the value".  I've yet to see you
come up with any reason why this is bad.

>> Of course, one can still change a gpio via /dev/mem or i2c-dev, depending on
>> the source.  How is being able to do this via sysfs any different?
>
> It's a question of how easy you make it to break things.
> You seem to draw the "too easy" line differently than I do.
> I don't want *anything* else mucking around with state my
> drivers are responsible for managing.

Will allowing userspace to request a gpio used by the kernel allow one to break
things easier than:
cat /dev/zero > /dev/hda

I don't think so.  Do you think allowing root to use a gpio after root has
specifically exported it will allow someone to break their system more easily
and to a greater extent than that command?  Yet that command has been around
since the existence of Linux, and the world hasn't come to an end.  Has there
even been a patch to remove a block device from userspace access once a
filesystem is mounted on it?  No?  Well then it's obviously not too dangerous,
if it's been there all along an no one has cared enough to remote it.  And if
gpio access is less dangerous than someone which is not too dangerous, then
gpio can't be too dangerous either then, can it?

Suppose I want to modify a i2c gpio extender's gpio value.  I can do
that *right now* like this:

i2cset 0 0x18 1 255 b 0x10

This ability has been around since i2c gpio drivers were first written!  Even
non-root can do that if the permissions are such.  Again, the world has not
ended.  No one is concerned enough about those foolish non-kernel programmers
modifying a gpio from userspace that they are doing anything about it.

It simply is not logical that a complex multi-step process of locating a gpio,
manually exporting it, and changing the value will be too dangerous, when
simpler means of doing the same thing have always existed and will continue to
exist and have not caused any problems.

The existing i2cset interface would allow one to change an input to an output
or write to the complelely wrong device if just one bit is written incorrectly
in the command.  Did you forget the datasheet uses 8-bit address and linux
uses 7-bit?  Well, you just overwrote your eeprom and bricked your system.  If
only a sysfs based system that doesn't require one to calculate hex constants
in their head existed, that would easily prevent mistakes like that.
