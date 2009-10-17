Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZJQLIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZJQLIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 07:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZJQLIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 07:08:14 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:51897 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZJQLIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 07:08:14 -0400
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Keeping network device renaming working in the presence of netconsole?
References: <87zl7rp1jy.fsf@spindle.srvr.nix> <1255723078.14249.16.camel@calx>
From: Nix <nix@esperi.org.uk>
Emacs: a real time environment for simulating molasses-based life forms.
Date: Sat, 17 Oct 2009 12:08:06 +0100
In-Reply-To: <1255723078.14249.16.camel@calx> (Matt Mackall's message of "Fri, 16 Oct 2009 14:57:58 -0500")
Message-ID: <87k4yup9bd.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-wuwien-Metrics: spindle 1290; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Oct 2009, Matt Mackall said:

> On Fri, 2009-10-16 at 20:43 +0100, Nix wrote:
>> This breaks userspace more than slightly if you rely on udev's
>> persistent net generator rules to keep network interface names constant,
>> or if you rename the lot to something more memorable than ethN. Any
>> userspace setup of that interface, assignment of additional addresses,
>> routing, MTU setting et al is all toast: and you can't stop using
>> interface renaming unless you like your interfaces to change identities
>> intermittently (but we've had that flamewar).
>
> A device definitely does have to be up for netconsole to work.

Thought so (hell, it brings it up itself). (I wish I knew how BMCs did
it, shadowing a real network device with a virtual one which can be
independently up and has a different MAC and everything. Probably it
takes hardware hacks.)

> But as far as I know, there's no good reason you can't rename an
> interface that's up.

I'll hack out the test and see what happens :)

> But back to your original problem: netconsole is actually probably a
> poor match for debugging suspend/resume as getting from an off state to
> a working state in the network driver takes a non-trivial amount of
> code.

I'm resuming from hibernation using TuxOnIce, so the network device has
initialized conventionally before the process state starts to
load, though it isn't *up* yet. (IIRC, anyway.)

(I probably used the wrong term: I always get suspension and hibernation
mixed up. This is a desktop, so the likelihood of suspend-to-RAM working
seemed remote, and also seemed unlikely to achieve the sorts of power
savings I was looking for.)

(Why TuxOnIce rather than swsusp? 'cos TuxOnIce was the only thing I
could ever get to work, is why, and 'cos it Just Worked until 2.6.31
when it suddenly started oopsing and panicking all over the place
in numerous exciting ways.)

> A useful technique here is capturing kernel message buffers in RAM
> across resets, something that can be done on most systems (provided you
> can disable memory test). Alternately, you might look at firewire
> techniques.

Neither of those work if the machine's been powered off for nine hours :)
