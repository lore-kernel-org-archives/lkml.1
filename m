Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbZFWPj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbZFWPj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbZFWPju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:39:50 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:52782 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751777AbZFWPjt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:39:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LYtsm3hGQx7sGemSwokloGtiyUsSVESv5nrrglSFQYTskjDpwVIo8ZveMQCAKP2gP58JDLHHmGMfmrSfed12bauJ70MvWbiVzbc3wYAJUTYvK+HosCpcf9mg5HzMirOa;
Date: Tue, 23 Jun 2009 08:39:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas@netline-mail2.netline.ch, Dave Airlie <airlied@linux.ie>,
       Andrew Lutomirski <luto@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.sf.net,
       Alex Deucher <alexdeucher@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm: previous pull req + 1.
Message-ID: <20090623083944.3e86ed2e@jbarnes-g45>
In-Reply-To: <1245743280.5580.2203.camel@thor.local>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	<4A3DABE1.50309@mit.edu>
	<alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	<alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	<alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	<cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	<alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	<alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	<4A3F3E3A.2030202@shipmail.org>
	<1245715213.4017.13.camel@pasglop>
	<alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
	<1245719079.4017.25.camel@pasglop>
	<20090622181832.771dac03@jbarnes-g45>
	<1245743280.5580.2203.camel@thor.local>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 09:48:00 +0200
Michel Dänzer <michel@daenzer.net> wrote:
> > > In fact, nowdays, we do have the infrastructure to be smart and
> > > enforce that. IE. Instead of using a boring remap_page_ranges() in
> > > fb_mmap() we could use a fault handler. When in KD_TEXT, we fail
> > > them, when in KD_GRAPHICS, we service them, and we
> > > unmap_mapping_range() when switching. Something like that...
> > > 
> > > Dunno how that interacts with the new DRM thingy though.
> > 
> > I think it could work, but ideally we'd keep the kernel fbcon object
> > pinned, and keep printing into it even while some other gfx app is
> > running.
> 
> It doesn't need to be pinned for that, does it? I think in the long
> run it's a bad idea to have it pinned all the time, think of machines
> with only 8 MB of VRAM...

Yeah, in the general case we shouldn't have to pin it...

> > (something like this would also be handy for dual head debugging;
> > one head running your desktop and the other a debug console
> > printing all the messages).
> 
> On a side note, I did precisely that about ten years ago on my
> Amiga. :) Granted, that was using two separate framebuffer devices (X
> glint driver on top of pm2fb, debug messages on amifb), but I think
> even that case isn't possible ATM. I agree it would be nice, though
> realistically there's hardly a way around a second machine for
> graphics driver development anyway.

Oh I know, most operating systems have reasonable debugging facilities,
and have had for a long time.  Linux is the one lagging here.

I agree it probably won't be that helpful for low level gfx debugging,
but I'm trying to think beyond that too. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
