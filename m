Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYKLVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYKLVxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYKLVxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:53:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59770 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYKLVxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:53:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Date: Wed, 12 Nov 2008 22:57:50 +0100
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20081109140726.GB1786@ucw.cz> <200811111747.28347.rjw@sisk.pl> <20081112104951.GB11945@ucw.cz>
In-Reply-To: <20081112104951.GB11945@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122257.50998.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of November 2008, Pavel Machek wrote:
> 
> > > > > Well, interesting point would be just before this commit:
> > > > > 
> > > > > 
> > > > > commit 8357376d3df21b7d6f857931a57ac50da9c66e26 
> > > > > tree daf2c369e9b79d24c1666323b3ae75189e482a4a 
> > > > > parent bf73bae6ba0dc4bd4f1e570feb34a06b72725af6 
> > > > > author Rafael J. Wysocki <rjw@sisk.pl> Wed, 06 Dec 2006 20:34:18 -0800 
> > > > > committer Linus Torvalds <torvalds@woody.osdl.org> Thu, 07 Dec 2006
> > > > > 08:39:27 -0800 
> > > > > 
> > > > >     [PATCH] swsusp: Improve handling of highmem
> ...
> > > And it does not work with single highmem page when NUMA is set... I
> > > went through the highmem saving code, and it depends on highmem not
> > > changing from  under it (right?) and is generally quite tricky ('if
> > > they are both in highmem do this, else if one of them is do that, else
> > > do something else')
> > 
> > It actually is quite simple, if you know the idea.
> > 
> > > and it changes page protections on the fly, etc. 
> > 
> > No, it doesn't do that, at least for pages it hasn't allocated itself.  I don't
> > think it changes anything like page protections at all, though.
> 
> safe_copy_page() seems to call kernel_map_pages() on s_page... which
> is page from the system AFAICT...
> 
> > > I'm not saying the bug is in that code, but before that commit we had
> > > very stupid --- but very robust -- code. I'll try if that one works
> > > with config_numa, perhaps we can get some debug info that way.
> > 
> > if you can do that, it actually may be valuable information.
> 
> So far I know that software suspend depends on !PAE in that old
> version. If I only recalled why...

It didn't create the temporary page tables during resume, IIRC.

Anyway, I have a real fix for this bug, will post in a little while.

Thanks,
Rafael
