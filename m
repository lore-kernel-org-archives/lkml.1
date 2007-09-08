Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXIHGaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXIHGaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 02:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXIHGai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 02:30:38 -0400
Received: from h3mxr01.htp-tel.de ([81.14.243.49]:24257 "EHLO
	H3MXR01.htp-tel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbXIHGah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 02:30:37 -0400
Message-ID: <46E24177.7070702@leemhuis.info>
Date: Sat, 08 Sep 2007 08:30:15 +0200
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Thunderbird 2.0.0.6 (X11/20070813)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Thorsten Leemhuis <fedora@leemhuis.info>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Andrew Morton <akpm@linux-foundation.org>, roger@computer-surgery.co.uk,
       linux-kernel@vger.kernel.org, perex@suse.cz
Subject: Re: easy alsa patches for the stable kernel?
References: <20070822222902.GA28563@computer-surgery.co.uk>	<20070905083844.6637da1e.akpm@linux-foundation.org>	<s5hlkbl6qsn.wl%tiwai@suse.de>	<20070905091633.87cfaa81.akpm@linux-foundation.org>	<s5hhcm96oza.wl%tiwai@suse.de>	<1189091390.3212.3.camel@rukbat>	<s5hir6n6ck6.wl%tiwai@suse.de>	<1189115313.7275.5.camel@rukbat>	<1189153347.15955.5.camel@rukbat>	<s5h7in26aj3.wl%tiwai@suse.de>	<46E13E31.1050409@leemhuis.info>	<s5hy7fi4oou.wl%tiwai@suse.de>	<46E1A9AC.1050601@leemhuis.info> <s5hsl5qhwqa.wl%tiwai@suse.de>
In-Reply-To: <s5hsl5qhwqa.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.09.2007 01:38, Takashi Iwai wrote:
> At Fri, 07 Sep 2007 21:42:36 +0200,
> Thorsten Leemhuis wrote:
> [...]
>> Sorry, but why?
>> It's just this line afaics...
>> +       SND_PCI_QUIRK(0x1179, 0xff50, "TOSHIBA A305", ALC268_TOSHIBA),
>> ...which afaics is doing nothing more then "if DMI-Data matches FOO then
>> apply know workaround BAR". Is that correct or am I missing something
>> here (another patch that this one depends on that isn't in 2.6.23 yet
>> maybe?)?
> The patch is based on the workaround codes that have been added after
> 2.6.23.  Thus the patch cannot work for 2.6.23 or earlier.

Yeah, that's why I said: you are in the best position to route patches
to stable and why I didn't send the patch for my particular problem to
the stable maintainers myself. ;-)

But there are now and then patches that just take care of applying
already known workarounds on specific machines automatically by adding
the proper DMI informations; here are some from 2.6.23 which might IMHO
would be of interest for 2.6.22.x as well:
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8f41b56645f03e6f50407211d6f0f0627ae95e4e
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=febe3375ea690a6cf544c33fa0fea1a06ff451ee
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8481da5a8d009d9bbac3d1483b579940e6dd9d59
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f8f794ab27dd3c6d9965ec5434775ead23d3d7a2
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ef64adbbba1b215e8b523b50ef9d568b4bf2e1e3
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7d87de2db2213e6e9413532445b14c92dae42c85

>>> The problem is often that I
>>> want first the merge to Linus tree, and then I forget to submit to
>>> stable tree when the merge takes long time in the end.  (Ther merge of
>>> alsa.git is too spotty, and that's another big problem for me.  In
>>> short, I do NOT maintain alsa.git tree at all...)
>> Then I as one of all those long-time-lkml-lurkers without programming
>> skills dare to say that maybe the alsa-project might need to improve its
>> workflow? Maybe you guys should maintain two git-trees (or multiple
>> branches in one tree; sorry, I'm not a git expert and not sure what the
>> correct terms are)?
> We do have different branches, too.  Most fix patches are usually in
> the branch to be pushed (although they are rarely done).

Well, the latter is IMHO one problem.

>  But, the point is that I am no official subsystem maintainer.

Well, I suppose he reads LKML now and then as well?

> I have an access right to add the patches to ALSA HG tree, which is
> converted to git tree automatically.  So, eventually, 90% of patches
> come from me.  But, the maintenance of git tree and push request are
> out of my hand.  It's a frustrating situation to me, too.

Yeah, I can feel your pain.

>> some will just say "linux sucks" and switch back to some other OS --
>> especially if they never have heard of alsa or don't really know what a
>> kernel really is or does.
> 
> Linux will suck really if one breaks so-called stable thing easily
> without actually testing.  For stable stuff, "it should be good" isn't
> enough.  It must be: "it IS good."

Linux IMHO will suck even more if crucial pieces of hardware does not
work for people easily, because Linux won't get even used then and will
frustrate people.

Don't get me wrong; I understand and agree mostly to the points you
raised. But we nevertheless need to find a way to make todays hardware
usable more quickly, as that hardware is often on the market only for
some months or a year until the successor-model replaces it (which might
need new drivers or workarounds) -- but it sometimes even for small
alsa-fixes takes as many months to make it from the developers out to
the kernel and from there to the distributions the user uses.

It works better in some areas of the kernels (SATA and Network drivers
come to my mind) where patches make it quicker into the linus- and
stable-kernels -- in parts that is due to better cooperation with the
hardware-vendors, but it seems the sub-tree maintainers have a better
patch-/workflow, which has a strong impact as well.

> [...]

CU
knurd
