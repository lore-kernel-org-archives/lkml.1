Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZCKNxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZCKNxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZCKNxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:53:40 -0400
Received: from mail10.dslextreme.com ([66.51.199.98]:40924 "HELO
	mail10.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752384AbZCKNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:53:40 -0400
Subject: Re: [PATCH] Re: ALSA HDA Intel stoped to work in 2.6.16-*
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <s5hsklknq9c.wl%tiwai@suse.de>
References: <87wtfhx7rm.fsf@nurf.casa> <s5hek1fmzf4.wl%tiwai@suse.de>
	 <gou8k9$reh$1@ger.gmane.org> <200903071900.44762.rjw@sisk.pl>
	 <s5h63ikjool.wl%tiwai@suse.de> <loom.20090308T231221-216@post.gmane.org>
	 <s5h8wncihmk.wl%tiwai@suse.de> <1236776849.4624.37.camel@the-omnibook>
	 <s5hsklknq9c.wl%tiwai@suse.de>
Content-Type: text/plain; charset=utf-8
Date: Wed, 11 Mar 2009 06:53:34 -0700
Message-Id: <1236779615.4624.51.camel@the-omnibook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, Rafael: The reason I originally sent this to the main LKML and not
to Takashi through other channels was that I was replying directly to a
thread already on only this list. I do acknowledge that this list was
not the proper venue for the thread when it was begun, three years ago.

On Wed, 2009-03-11 at 14:27 +0100, Takashi Iwai wrote:
> At Wed, 11 Mar 2009 06:07:20 -0700,
> Daniel Gimpelevich wrote:
> > 
> > (Re-adding mistakenly snipped CC's…)
> > 
> > On Wed, 2009-03-11 at 09:33 +0100, Takashi Iwai wrote:
> > > At Sun, 8 Mar 2009 23:21:13 +0000 (UTC),
> > > Daniel Gimpelevich wrote:
> > > > 
> > > > Takashi Iwai <tiwai <at> suse.de> writes:
> > > > 
> > > > > Daniel, how "incorrect" do you mean exactly?
> > > > > 
> > > > > As you cited, the above patch was added for the request for the
> > > > > specific model, so the patch itself is correct per definition.  What
> > > > > wrong could be the choice of the model option by the original poster,
> > > > > which I cannot judge.
> > > > > 
> > > > > Of course I have no objection to fix the model entry at all, but I
> > > > > need a more proper justification.
> > > > 
> > > > The master volume control appeared to be affecting the wrong control line,
> > > 
> > > Is it so with the latest 2.6.29 kernel?
> > > (Also you aren't accessing pulse plugin, right?)
> > 
> > Was using alsamixer to test, without pulseaudio running. The underlying
> > issue is unchanged in three years of commits.
> 
> No, the master volume behavior did change recently.
> 
> Doesn't it really work with model=basic on 2.6.29?
> Its master should change both the widget 0x08 and 0x09, so it should
> influence on the volume.

Perhaps; I was referring only to the issue of model=basic being chosen
as a lowest common denominator amidst lack of other info. The newest
kernel I have actually tested on that hardware so far is the one on the
Fedora 10 LiveCD.

> > > > and
> > > > there was no way to turn off IEC958, which appeared to be on by default.
> > > 
> > > This should work.
> > > 
> > > 	% amixer -Dhw:0 set IEC958 mute
> > 
> > It does work, but only after the patch I submitted (or by using the
> > equivalent module argument).
> 
> Ah, you mean there is no IEC958 mixer as is, right?  Then yes, there
> is no control with model=basic.
> 
> But, I basically wonder whether model=auto works or not.
> Choosing an existing model for a device of another vendor is often
> wrong in small corner cases.

As the OP stated, there is no sound output whatsoever with model=auto.
The controls in alsamixer in that case do not exactly match any of the
existing models, and I currently intend to attach a three-way comparison
of them among model=basic, model=will, and model=auto.

> Anyway, it'd be helpful if you attach the output of alsa-info.sh (with
> --no-upload option) on your device.  The script is found at
>     http://www.alsa-project.org/alsa-info.sh

Unfortunately, the machine has since suffered a hardware failure, which
I will attempt to correct this week. Further testing must wait until
then.

