Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbYD3RqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbYD3RqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbYD3RqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:46:14 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:56662 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246AbYD3RqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:46:13 -0400
Message-ID: <4818B057.4080803@aknet.ru>
Date: Wed, 30 Apr 2008 21:45:59 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: patch	driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
 added to gregkh-2.6 tree
References: <12094266793898@kroah.org>	<4816A888.9000802@aknet.ru>	<20080429045849.GA6348@suse.de>	<s5habjdvt6z.wl%tiwai@suse.de>	<481776EA.5010200@aknet.ru> <s5h7ief7sw3.wl%tiwai@suse.de>
In-Reply-To: <s5h7ief7sw3.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
>> I was trying this in the past.
>> This never worked out very well.
> Why?
Mainly because I was not able to
come up with the good hooks for the
pcspkr driver, and those I tried,
were not applied.
There was a lengthy thread about that.
Now I can't find its beginning and its
end, but some is here:
http://www.ussg.iu.edu/hypermail/linux/kernel/0603.2/3096.html
I also think you were CCed, but maybe
not.

>> I disliked the dependancies.
>> Either snd-pcsp was loading pcspkr,
>> or there had to be the global variable
>> to prevent the concurrent access, and
>> that hurts modularity.
> But you anyway enable the input pcspkr feature in your snd-pcsp code.
> So, basically you depend on (or build on) it.
If they are separate, then "rmmod pcspkr"
should disable the beeps. I don't want
to fuzzy that logic up to something like
- Check if snd-pcsp is loaded
- Use alsamixer to disable beeps, if
it is.
- Use rmmod pcspkr if it is not.
I think there should be always a single
way for the user to disable the beeps.
Now he can choose it by chosing the driver.

>>> What we'd need is a hook on
>>> pcspkr.c that adds a dynamic check whether snd-pcsp (or any ohter)
>>> is running.
>> How?
> What you need is a way to check whether input pcspkr can be usable or
> not.  You can add a function pointer, for example.
Could you please clarify?
- Should snd-pcsp then forcibly select
pcspkr.c to compile?
- What exactly function pointer, and
where to add?

>> And also, with snd-pcsp you have a
>> mixer control to disable the beeps,
>> which I find sometimes even more
>> usefull than the pcm sound itself. :)
> Yes, that seems useful.
Yes, but problematic when they are separate.
I was trying to add an input event to shut
up pcspkr.c, but that was rejected. Everything
else will introduce the dependancy. The
dependancy will block rmmod, obfuscating the
logic of disabling the beeps.
Just for the record, what problems do you
see with the current solution, where only
one driver drives the device? That looks
rather logical to me. And I also can remember
the complains about pcspkr driver being in
an input drivers section. Some people had
problems finding it there and were asking
to move it to sound menu.
