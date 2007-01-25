Return-Path: <linux-kernel-owner+w=401wt.eu-S1030615AbXAYWAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030615AbXAYWAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 17:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030620AbXAYWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 17:00:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:54404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030615AbXAYWAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 17:00:43 -0500
Date: Thu, 25 Jan 2007 13:59:43 -0800
From: Greg KH <greg@kroah.com>
To: xiphmont@xiph.org
Cc: Takashi Iwai <tiwai@suse.de>, Pierre Ossman <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       Lennart Poettering <lennart@poettering.net>, perex@suse.cz
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Message-ID: <20070125215943.GC3126@kroah.com>
References: <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com> <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com> <s5h7ivbuhg1.wl%tiwai@suse.de> <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com> <s5h4pqfufs8.wl%tiwai@suse.de> <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com> <s5h1wljuf2f.wl%tiwai@suse.de> <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com> <20070125194933.GA27857@kroah.com> <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 03:40:06PM -0500, xiphmont@xiph.org wrote:
> >Basically, new distros can disable that option if their userspace can
> >handle the new structure of sysfs with the symlinks.  Users of older
> >distros with newer kernels can enable the option and (hopefully) not
> >break anything.
> 
> I would like to register a general objection to a change of this size
> 'hoping to not break anything' in a stable release update (seeing as
> how something did break), especially as how no one here who was
> maintaining the userspace was apparently even aware it was coming.

There is no such thing as a "stable release update" series anymore, you
should know that :)

It's incremental changes, over time, evolving into something new as you
look at the larger picture.

> >So far, it's been working with this being the first
> >regression reported.
> 
> Had it worked properly, it still would have been a regression.  This
> seems similar to the ALSA copout ("maintaining a kernel ABI is hard!
> We require you have a userspace officially approved by us matching
> your kernel, and that is your API.") except that in this case, the
> userspace maintainence doesn't seem to be as tightly coupled (is hald
> the only thing that broke?)

Well, as this HALD issue is the only thing that I have had reported, and
these patches have been in the -mm tree for quite some time, yes, I
think it is the only thing that has broken.

And yes, we have to have a way to evolve the api over time.  I thought
that given a kernel config option to allow the api to change, if your
userspace has also been updated, is the perfict way.  Then new distro
releases get to take advantage of the new stuff in the kernel, and we
don't break people who cling to Fedora Core 3 while wanting to run new
kernels (hi Andrew...)

In short, it's a bug, I messed up somehow.  And I'm trying to fix it
now, I don't think there's more that I can do, do you?

> >> (Well, it's incomplete like my original patch was in that it only
> >> changed the device symlinks for controlX and pcmX; the other entries
> >> still had device entries pointing at card*).
> >
> >So what does running with this patch make sysfs look like?
> 
> A union of old and new, with old taking precedence over new when they
> conflict.  That is, the [eg] pcmCXdXx entries look like old sysfs, but
> the new entries for cardX etc are there too.  All device symlinks
> point to /sys/device/pciXXXX:XX/XXXX:XX:XX.x entries as before.

Can you give me the 'tree /sys/class/sound' output?

Does it work properly with old versions of hald now?

Is there anything else left to fix?

thanks,

greg k-h
