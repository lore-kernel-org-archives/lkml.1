Return-Path: <linux-kernel-owner+w=401wt.eu-S1763526AbYBLSYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763526AbYBLSYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbYBLSYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:24:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:54925 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991AbYBLSYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:24:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HGaPABLLUNphY+1sSTeDS4QjmCzmRPc76f+proiDScZRKKHabyu7mLSBNBn6lnWh+2gIDAzt3wI6FXZRevPdl+ewFnJSifvjnk64y6h7qnncnRqoe1fbHvH9dKyHJEO+lf8rUDXaGxKz+edQ2CfbWui0ttml7yC5wBQYFrQ/oM0=
From: Matej Laitl <strohel@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Tue, 12 Feb 2008 19:24:35 +0100
User-Agent: KMail/1.9.7
Cc: alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802112158.41989.strohel@gmail.com> <200802121627.44422.strohel@gmail.com> <s5hmyq6t7u5.wl%tiwai@suse.de>
In-Reply-To: <s5hmyq6t7u5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121924.35232.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Matej Laitl wrote:
> > Yes, this "slightly better" patch applied on top of your first patch
> > against hda_codec.c did the trick, but with some side-effects:
> > * the "Speaker" switch now mutes/unmutes speakers
> > * muting/unmuting "Front" channel now has zero effect (in 2.6.24 it had
> > the same effect as the "Speaker" switch now has)
> > * changing volume on "Front" channel now affects volume in headphones
> > (was not so in 2.6.24)
>
> This is what your BIOS sets up.  The main output is connected to the
> docking station.  That's why "Front" (a silly name for ALC262; it
> should read "Line Out", maybe will be renamed in later versions)
> switch doesn't work.
> OTOH, all outputs (speaker, headphone and line-outs) use the same DAC,
> and this is controlled via line-out volume, i.e. "Front" volume.

I was actually wrong when saying the "Front" channel did not influence HP-out 
in 2.6.24 - it did, so no regressions here.

> > So there are now 3 vol controls that affect both speakers and headphones:
> > * Master (which appeared somewhere between 2.6.24 and .25-rc1), when set
> > to zero, the sound is still audible in speakers and headphones
>
> This must be the behavior of the codec chip...  Did "Front" volume 0
> mute in the earlier version?  If not, it actually doesn't mute with
> the lowest volume.  Use the master switch to mute.
>
> Anyway, attach the alsa-info.sh output at the moment Master volume is
> zero.

No, setting Master and/or Front channel to 0% did not mute audio in any 
version I used.

I'm now listening to music with Master=0% and Front=0%, the sound is at well 
audible volume. Pastebin for this configuraion is here:
http://pastebin.ca/901459

However I don't consider it a problem, it's mutable by PCM and HP/Speaker 
switches. Funny thing is that resulting volume of those 3 setting is equal:
* Master=0, Front=0
* Master=100%, Front=0
* Master=0, Front=100%
But when both set to let's say 50, changing one of these audibly affects 
resulting volume.

> > * PCM, working as expected (0 volume = no sound)
> > * Front (0 volume = still audible sound)
> >
> > So it is usable now (and those Speaker and Headphones on/off switches
> > make sense), but kinda suboptimal. (is it my BIOS who is to blame?)
>
> Yep.  For the perfect solution, you'd need to create a static "patch"
> for this particular model instead of auto-configuration.  Then you can
> adjust everything as you like.

Would it be easy to do this in a robust way? If not, it's not worth it.

On a side note, I experience increased noise when not playing anything during 
2.6.24 -> .25-rc1 upgrade, but this is probably completly unrelated to 
today's problem.

Anyways, thanks for your effort and patches, Takashi.

Matej Laitl
