Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbXIGToq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbXIGToq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbXIGToi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:44:38 -0400
Received: from h3mxr02.htp-tel.de ([81.14.243.50]:29940 "EHLO
	H3MXR02.htp-tel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbXIGToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:44:37 -0400
Message-ID: <46E1A9AC.1050601@leemhuis.info>
Date: Fri, 07 Sep 2007 21:42:36 +0200
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Thunderbird 2.0.0.6 (X11/20070813)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Andrew Morton <akpm@linux-foundation.org>, roger@computer-surgery.co.uk,
       linux-kernel@vger.kernel.org, perex@suse.cz
Subject: Re: easy alsa patches for the stable kernel?
References: <20070822222902.GA28563@computer-surgery.co.uk>	<20070905083844.6637da1e.akpm@linux-foundation.org>	<s5hlkbl6qsn.wl%tiwai@suse.de>	<20070905091633.87cfaa81.akpm@linux-foundation.org>	<s5hhcm96oza.wl%tiwai@suse.de>	<1189091390.3212.3.camel@rukbat>	<s5hir6n6ck6.wl%tiwai@suse.de>	<1189115313.7275.5.camel@rukbat>	<1189153347.15955.5.camel@rukbat>	<s5h7in26aj3.wl%tiwai@suse.de>	<46E13E31.1050409@leemhuis.info> <s5hy7fi4oou.wl%tiwai@suse.de>
In-Reply-To: <s5hy7fi4oou.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.2007 14:58, Takashi Iwai wrote:
> At Fri, 07 Sep 2007 14:04:01 +0200,
> Thorsten Leemhuis wrote:
>> On 07.09.2007 12:21, Takashi Iwai wrote:
>>> At Fri, 07 Sep 2007 10:22:27 +0200,
>>> Romano Giannetti wrote:
>>>> Takashi: good news!
>>>>
>>>> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
>>>> index 3557865..496d119 100644
>>>> --- a/sound/pci/hda/patch_realtek.c
>>>> +++ b/sound/pci/hda/patch_realtek.c
>>>> @@ -9044,6 +9044,7 @@ static const char *alc268_models[ALC268_MODEL_LAST] = {
>>>>  static struct snd_pci_quirk alc268_cfg_tbl[] = {
>>>>         SND_PCI_QUIRK(0x1043, 0x1205, "ASUS W7J", ALC268_3ST),
>>>>         SND_PCI_QUIRK(0x1179, 0xff10, "TOSHIBA A205", ALC268_TOSHIBA),
>>>> +       SND_PCI_QUIRK(0x1179, 0xff50, "TOSHIBA A305", ALC268_TOSHIBA),
>>>>         SND_PCI_QUIRK(0x103c, 0x30cc, "TOSHIBA", ALC268_TOSHIBA),
>>>>         SND_PCI_QUIRK(0x1025, 0x0126, "Acer", ALC268_ACER),
>>>>         SND_PCI_QUIRK(0x1025, 0x0130, "Acer Extensa 5210", ALC268_ACER),
>>> Ah good.  I added it to ALSA HG tree now.
>> Just wondering: should easy-and-obvious and less-risky patches like this
>> one be send to the stable-kernel-maintainers in parallel to adding them
>> to the HG-Tree (or shortly afterwards)? It could safe users lots of
>> trouble if such improvements make it quickly into production-ready
>> kernel-releases (and from there they might even find their way into some
>> distribution kernels quickly). Hardware then would "just work".
> Well, this patch is defenitely not for 2.6.23 or stable kernel.
> It's for 2.6.24.

Sorry, but why?

It's just this line afaics...
+       SND_PCI_QUIRK(0x1179, 0xff50, "TOSHIBA A305", ALC268_TOSHIBA),
...which afaics is doing nothing more then "if DMI-Data matches FOO then
apply know workaround BAR". Is that correct or am I missing something
here (another patch that this one depends on that isn't in 2.6.23 yet
maybe?)?

If my above analyze is correct (which IMHO is at least correct for some
of all those alsa-patches that get applied) then I'd say: it's worth
applying them to linus-git tree even after the merge-window, as the risk
that something is wrong is small (¹) and the benefit for users is big
enough to be worth the risk, as users get the fix in their hands 60 - 80
days (round about the time a typical devel cycle takes these days
afaics) earlier that way.

60 - 80 days might sound like not that much to some people, but if we
want to make Linux compatible to todays hardware (and not only
yesterdays) we imho can't wait nearly 1/4 of a year (or longer, as it
takes some time until such a fix hits the distributions, but that's
another part of the problem), as a typical market-lifetime of a modern
notebook is often not much longer then a year in total afaics.

(¹) -- sure, typos or stupid side-effects can happen always -- but
that's not enough a reasons to stand still

>> Sure, before the stable-maintainer will take such patches they needs to
>> be added to linus git-tree beforehand as well. And sure, patches like
>> the one above are not fixing a regression (at least in this case if I
>> read the thread correctly; the old subject thus is misleading afaics),
>> but it's similar to a new PCI-ID that gets added to a existing driver --
>> and that's done now in the stable-series afaics (¹).
>>
>> The alsa-maintainers seem to be in the best position to do this, but it
>> seems they rarely do it. I for example was hit by a regression (sound
>> worked in 2.6.20 and broke afterwards; was fixed in 2.6.23-git by the
>> following patch in case anybody is wondering:
>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a4eed138add1018846d17e813560b0c7c0ae8e01
>> ), but the alsa-developers did not submit it for stable afaics. Sure, I
>> could do that myself, but as I said: the alsa-maintainers really have
>> the best overview over the alsa-patches and should know which patches
>> are safe to apply for older kernels.
> 
> I occasionally do but sometimes forget. 

Nevertheless let me use to use this moment and say: thx for all your
work Takashi!

> The problem is often that I
> want first the merge to Linus tree, and then I forget to submit to
> stable tree when the merge takes long time in the end.  (Ther merge of
> alsa.git is too spotty, and that's another big problem for me.  In
> short, I do NOT maintain alsa.git tree at all...)

Then I as one of all those long-time-lkml-lurkers without programming
skills dare to say that maybe the alsa-project might need to improve its
workflow? Maybe you guys should maintain two git-trees (or multiple
branches in one tree; sorry, I'm not a git expert and not sure what the
correct terms are)?

E.g. look at how Jeff handles it for libata; he pushes big stuff during
each merge window; after that lots of small updates (new PCI-IDs) and of
course fixes make it to tree quite often (weekly normally afaics,
sometimes more often, sometimes more seldom) until nearly right before
the release of a new Linus-Kernel -- bigger stuff in parallel gets into
another branch, which gets testing in -mm and in parts gets merged
during the next merge-window.

And even better: he pushes small improvements like the PCI-IDs (see
links I gave earlier) to the stable tree as well. That, afaics, happens
in just a few days sometimes; this is how it looks to me from the outside:

- jeff prepares his tree with a patch that for example adds two new
PCI-IDs to a existing driver
- he asks linus to pull it and waits to do that
- some days after linus pulled them jeff pushes the patch to another
git-branch/tree and asks the stable-guys to pull that one, which they do
sooner or later

For alsa it's seems there is only the hg-tree which gets everything
(small and big updates) that has to wait for the next merge-window to
get into the proper kernel (but not into stable). E.g. in the worst case
it might nearly take a half a year until even a small patch gets out to
the users if that patch was made right after a merge window got closed
for a release. That's IMHO way to long.

> Another problem I see is that we have little chance for testing the
> target patches with stable kernels.

The stable maintainers release "rc" kernels before they release the
final ones. And the patch of course should have been applied in
linus-tree. Both things are not a perfect safety net, but I'd say it
should be more then enough as long as we are talking about new PCI-IDs
for existing drivers or "apply workarounds for special machines which we
detect by their DMI data" (lot's of those seems to be needed these days).

>  Even it looks OK and works for
> the later kernels, it often doesn't work or break magically with the
> older kernels.  Usually, I have no affected hardware, and bug
> reporters test only with the recent version (partly because developers
> ask first to try the latest version -- if it works, why to downgrade
> again?) 

Because he bug-reporter is likely only one that invested enough time to
analized the problem and fix it alone or together with you guys. But
there is likely a buch of other people that get hit by the same problem;
some will just say "linux sucks" and switch back to some other OS --
especially if they never have heard of alsa or don't really know what a
kernel really is or does.

CU
knurd
