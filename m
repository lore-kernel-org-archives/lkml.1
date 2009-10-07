Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZJGF6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZJGF6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 01:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZJGF6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 01:58:20 -0400
Received: from smtpout12.uol.com.br ([200.221.4.203]:49495 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751488AbZJGF6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 01:58:19 -0400
Date: Wed, 7 Oct 2009 02:57:27 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: bugzilla-daemon@bugzilla.kernel.org
Cc: Denys Rogovchenko <denisius.sion@gmail.com>, rbrito@users.sf.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Artem S. Tashkinov" <t.artem@mailcity.com>,
       ykzhao <yakui.zhao@intel.com>, len.brown@intel.com, gmaizel@gmail.com,
       linux-kernel@vger.kernel.org, Jaime Gimeno <xaumexemuax@yahoo.es>
Subject: Re: [Bug 11255] S3: no resume, not even a beep - LG R700
Message-ID: <20091007055727.GA17151@ime.usp.br>
References: <bug-11255-5003@http.bugzilla.kernel.org/>
 <200909291835.n8TIZigc018246@demeter.kernel.org>
 <8BDFD7B4-ABB5-45BD-BBC9-21C6AC4F48E9@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8BDFD7B4-ABB5-45BD-BBC9-21C6AC4F48E9@ime.usp.br>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SIG5: af4e21f34fa4d2ce4c79535d3b3b25c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rafael and other people.

First some context:

On Sep 29 2009, Rogério Brito wrote:
> Well, I have some quite detailed debugging information on the bug
> that I reported and that was considered as a duplicate of this one.
> 
> "My bug" is http://bugzilla.kernel.org/show_bug.cgi?id=11717, where
> I detail a lot of what has been done. Actually, I even filmed what
> the notebook does, but I, then, deleted it, given the 10 or more
> months that have already passed since I first reported this issue.
> 
> I can film it again, if it is desired.
> 
> I can really understand what other bug reporters feel (frustration
> is the right word) given that we spent so much on this. :-(
(...)

On 2009-09-30, Rafael J. Wysocki wrote:
> Rogério, thanks a lot for the information.
>
> Did you try any tests with /sys/power/pm_test or did you try to use PM_TRACE?

I did a good amount of tests.

Yes, I did do tests with /sys/power/pm_test. The results (in an
ascii-art table) that I got with kernel 2.6.31-rc5 were:

test with /s/p/pm_test |  result
-----------------------+------------------------
core                   | comes back from "sleep"
processors             | comes back from "sleep"
devices                | comes back from "sleep"
"none"                 | hangs in the real test

I'm writing this from memory, but I can repeat the tests, of course. It
would be nice if other reporters also did the same, so that we can
isolate the problem here.

Or, if they already did the tests, it would be nice if they could
summarize the tests.

I also tried to use /sys/power/pm_trace, but without much success.  I
don't remember any hash or matches line, but I can, of course, try it
again.

Oh, just so that you get an idea of what happens with my computer (and I
would love it if the other reporters confirmed what they are seeing),
here is what happens when I press the sleep button under any kernel that
I tried:

,----
| * the machine goes to sleep, staying with the light on the power button
|   blinking;
| 
| * if I press the button again, the notebook gives all symptoms of
|   resuming;
| 
| * just when you think that it will wake up, it turns itself off;
| 
| * after 1 or 2 seconds, when you think that it is powered off, it
|   turns itself on again (yes, "out of the blue");
| 
| * after that, it hangs with a black screen and no responses, no
|   feedback, no network activity (I tried to ssh into it), no pings, no
|   Magic SysRq, no nothing.
`----

Under Windows Vista (that came preinstalled), I do:

,----
| * press the power/sleep button;
| * the machine goes to sleep;
| * press the power/sleep button again;
| * the machine comes from sleep.
`----

I have already tried to:

* enable and disable Kernel Modesetting (it's an ICH8-based chipset);
* booted with a full system;
* booted with init=/bin/bash (so, no acpid taking over /proc/acpi/event);
* upgrade and downgrade the BIOS version;
* used kernels from 2.6.24 to 2.6.31-rc8.

I also tried ykzhao's suggestion of

  "echo mem > /sys/power/state; dmesg > dmesg_after; sync;"

but, as I naively would expect, there's no time for a dmesg to be
written to the disk, apparently.

Oh, I read some of the other bug reports and it seems that the other
posters also have a realtek 8169-driven ethernet card (can you confirm,
people?).

I tried "ifconfig eth0 down"'ing and even removing the module before
putting it to sleep, but no success either.

Well, as you can see, there's something highly magical that Windows
seems to be doing here that Linux can't (up to now).

As always, I am open to any suggestions and can perform any tests that
you want me to (and I can reconduct anything that was done already).


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
