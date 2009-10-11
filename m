Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZJKVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZJKVlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZJKVlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:41:36 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:46742 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbZJKVlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oBz6wOMKpOTNhMCoLW/1MzOVh5HLXti24W/SWv9i0yasIhOyoqExttyFmrHB3UEPwn
         GcNjJMJ8sFwzUyfyfgElKRKmzN8Orajg2AvxmI9tO0agw3W0V+g5adJpRbOFW6xI2Uq6
         bMGRn7T2HO6I2969aDRdSQ1hvdxJXvpZbEcEU=
Date: Sun, 11 Oct 2009 23:40:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch 11/28] nvram: Drop the bkl from nvram_llseek()
Message-ID: <20091011214053.GD5486@nowhere>
References: <20091010153314.827301943@linutronix.de> <20091010153349.499835683@linutronix.de> <200910112131.40608.arnd@arndb.de> <20091011210809.GC5486@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011210809.GC5486@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 11:08:10PM +0200, Frederic Weisbecker wrote:
> On Sun, Oct 11, 2009 at 09:31:40PM +0200, Arnd Bergmann wrote:
> > On Saturday 10 October 2009, Thomas Gleixner wrote:
> > > There is nothing to protect inside nvram_llseek(), the file
> > > offset doesn't need to be protected and nvram_len is only
> > > initialized from an __init path.
> > > 
> > > It's safe to remove the big kernel lock there.
> > > 
> > 
> > The generic_nvram driver still uses ->ioctl instead of ->unlocked_ioctl.
> > I guess it would be helpful to change that in the same series, so we
> > don't get the BKL back as soon as someone does a pushdown into the
> > remaining ioctl functions.
> > 
> > 	Arnd <><
> 
> 
> Right!
> I'll add that in a second patch.
> 
> I've completely forgotten this ioctl/unlocked_ioctl thing.


BTW, I was focusing on the lock_kernel() callsites in the kernel which
are around 626 (I've excluded reiserfs)

Now I'm adding the ioctl() sites too:

git-grep "\.ioctl *=" | grep -P "^\S+\.c" | wc -l
452

Hehe :)

