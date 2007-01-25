Return-Path: <linux-kernel-owner+w=401wt.eu-S1030531AbXAYTuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030531AbXAYTuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030534AbXAYTuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:50:40 -0500
Received: from mail.suse.de ([195.135.220.2]:45522 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030531AbXAYTuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:50:39 -0500
Date: Thu, 25 Jan 2007 11:49:33 -0800
From: Greg KH <greg@kroah.com>
To: xiphmont@xiph.org
Cc: Takashi Iwai <tiwai@suse.de>, Pierre Ossman <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       Lennart Poettering <lennart@poettering.net>, perex@suse.cz
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Message-ID: <20070125194933.GA27857@kroah.com>
References: <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com> <s5hfy9zujvr.wl%tiwai@suse.de> <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com> <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com> <s5h7ivbuhg1.wl%tiwai@suse.de> <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com> <s5h4pqfufs8.wl%tiwai@suse.de> <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com> <s5h1wljuf2f.wl%tiwai@suse.de> <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 01:51:42PM -0500, xiphmont@xiph.org wrote:
> On 1/25/07, Takashi Iwai <tiwai@suse.de> wrote:
> 
> >> [This does beg the question: Does the benefit of this complete
> >> restructuring in a subminor release of an allegedly stable kernel
> >> outweigh the fact that it breaks all audio for any user running a
> >> gnome desktop?]
> >
> >Well, that's not me who introduced that ;)
> 
> Consider it addressed to those responsible.

Which would be me. :)

And no, I don't want to break anything, hence that config option.  If
it's enabled, sysfs should look just like before.  But it looks like we
messed up somewhere and we need to fix it

> >Also, avoid creating card* instance.  It makes no sense in that case.
> 
> Well, the 'new' entries don't interfere with old-- and we inevitably
> are going to end up with a situation where some software can only read
> the 'new' entries and some software can only read the 'old', otherwise
> why offer compatability at all?  I interpreted the
> CONFIG_SYSFS_DEPRECATED option to mean 'also offer the deprecated
> entries in addition to the new structure', otherwise the name should
> be CONFIG_SYSFS_OLDSTYLE or some such to imply they're mutually
> exclusive....

The name of the config option doesn't really matter as much as the help
text of the option does.  Does reading that help out more?

Basically, new distros can disable that option if their userspace can
handle the new structure of sysfs with the symlinks.  Users of older
distros with newer kernels can enable the option and (hopefully) not
break anything.  So far, it's been working with this being the first
regression reported.

> >(So... what's wrong with my patch?)
> 
> As it turns out, nothing (I made some error somewhere initially when
> testing it).
> Apologies if I wasn't clear.
> 
> (Well, it's incomplete like my original patch was in that it only
> changed the device symlinks for controlX and pcmX; the other entries
> still had device entries pointing at card*).

So what does running with this patch make sysfs look like?

thanks,

greg k-h
