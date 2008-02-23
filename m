Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYBWPRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYBWPRW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbYBWPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:17:04 -0500
Received: from 87-237-56-54.northerncolo.co.uk ([87.237.56.54]:59590 "EHLO
	totally.trollied.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbYBWPQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:16:32 -0500
X-Greylist: delayed 4902 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2008 10:16:32 EST
Date: Sat, 23 Feb 2008 13:53:35 +0000
From: John Levon <levon@movementarian.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080223135335.GA28464@totally.trollied.org.uk>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223113724.GB31304@elte.hu>
X-Url: http://www.movementarian.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Obviously I hold no sway here, so there's little point in my continuing
to try and fight this madness, but I have to say my piece. Don't worry,
I'll leave it after this - I know Ingo always gets his way.

On Sat, Feb 23, 2008 at 12:37:24PM +0100, Ingo Molnar wrote:

> and ask him to try oprofile and then to try sysprof as a comparison - to 
> and figure in which app and which function the overhead is.

Now work out whether this is a result of the kernel code or not. Whilst
there's probably no point me stating this: I object most strenuously to
the idea of merging duplicate code that does part of what oprofile does.

Soren wrote sysprof when he tried an earlier version of oprofile and
found it slightly non-obvious. Instead of doing any of these things:

- complaining to the oprofile list
- checking a version of oprofile written in the last two years
- fixing oprofile user space to be more obvious

he just went on right ahead and re-implemented it so he could write a
GUI on top of it. That *exact same GUI*  could have been on top of
oprofile. Usability problems with opcontrol or opreport could have been
reported (or even - gosh - fixed). Soren was too lazy.

It seems the same applies to you and Arjan, at least.

> It's 200 lines of pretty well isolated code for something that is 
> already much more usable to me than 10 years of oprofile. Really, i'd 
> much rather take 200 lines of poor kernel code written by a userspace 
> developer for stuff that _already works better_, than to have ~2000 
> lines of oprofile code and an unusable (to me) user-space tool written 
> by kernel developers.

I honestly can't believe that you're telling me you'd rather have more
kernel code than make some tweaks (which, by the way, you have NEVER
complained about to me or to the oprofile mailing list until now)
to a shell script. Specifically:

>   [ Newbie: WTF, no GUI tool? ]

Wrong. It's shipped with a (rather poor) GUI pretty much since
inception. More recently, there's been at least two GUIs. For example:

http://labs.o-hand.com/wp-content/uploads/2007/12/oprofileui.png

>   # opcontrol
> 
>   [ Newbie sees tons of output. User scratches head. After looking 
>     around, finds the following option listed:
>     "-s/--start       start data collection". That must be it! ]
> 
>   # opcontrol -s
>   No vmlinux file specified. You must specify the correct vmlinux file, e.g.
>   opcontrol --vmlinux=/path/to/vmlinux
>   If you do not have a vmlinux file, use
>   opcontrol --no-vmlinux
>   Enter opcontrol --help for full options
> 
>   [ Newbie: WTF? Doesnt oprofile think that what I want to do is to 
>     profile ... the currently running kernel, wherever a kernel is 
>     and whatever a vmlinux might be?? ]

Firstly, the distributions should have set this up automatically. That
they don't is a distributor bug. The sheer madness of Linux not leaving
a vmlinux file in a stable known location is hardly something oprofile
can be blamed for.

Secondly, not ONE PERSON INCLUDING YOU has EVER suggested to us that we
default to no vmlinux.

>   [ The newbie user eventually finds out that opcontrol help text is 
>     buggy and that -s does not mean --start, but --setup. ]

It's astonishing that you would know about this, complaining about this,
but not file a bug report. Same goes for the rest.

And once again, please explain how the buggy shell script has anything
to do with kernel code.

What, exactly, happened to scratching an itch? If everyone should be
hanging his head in shame, Ingo, why haven't you used your considerable
influence to find a maintainer for OProfile to fix the (until now,
private to you) issues you have with it? Shameful? Indeed.

john
