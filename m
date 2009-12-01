Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZLAJuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZLAJuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZLAJuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:50:19 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:34049 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZLAJuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:50:17 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 04:50:17 EST
X-Spam-ASN: 
X-Spam-Hammy: 0.000-+--HCc:D*org, 0.000-+--H*Ad:D*kernel.org,
	0.000-+--H*Ad:D*vger.kernel.org
X-Spam-Spammy: 0.965-+--H*Ad:U*daniel.vetter, 0.950-+--H*r:mail.ffwll.ch,
	0.948-+--H*Ad:D*ffwll.ch
Date: Tue, 1 Dec 2009 10:42:23 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: specify absolute paths for cscope
Message-ID: <20091201094222.GC9177@viiv.ffwll.ch>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
References: <1259238852-21214-1-git-send-email-daniel.vetter@ffwll.ch>
 <4B13FD4B.5080805@suse.cz>
 <20091130181109.GA19614@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130181109.GA19614@merkur.ravnborg.org>
X-Operating-System: Linux viiv 2.6.32-rc8-00035-gb7e1d0d 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 07:11:09PM +0100, Sam Ravnborg wrote:
> On Mon, Nov 30, 2009 at 06:13:47PM +0100, Michal Marek wrote:
> > On 26.11.2009 13:34, Daniel Vetter wrote:
> > > Some tools (like my favourite editor, vim) can't handle relative
> > > paths from cscope as soon as cscope.out is no longer in $PWD. Use
> > > absolute paths when generating cscope.files, which seems to be
> > > the recommended way to generate cscope.out, anyway (at least according
> > > to cscope.sf.net).
> > 
> > But it will fail if you rename the source directory. I'm not sure what
> > is worse, I myself don't use cscope much. Fixing vim would be the ideal
> > solution of course (it already handles ../tags fine).
> 
> For tags I recall we fall back to absolute path only for O=... builds.
> This made the tags file considerably smaller for a non O=.. build
> thus speeding up the search.
> 
> So unconditionally using absolute paths for cscope may have drawbacks.

I've just tried to use cscope with a working directory not equal to the
directory where cscope.out resides:

$ cscope -d -f src/cscope.out

It can't handle relative paths. When I try to open a file (via a
reference) from within cscope, it calls up vim with the wrong path.  So I
think this is a fundamental cscope bug (and not a vim problem).  As I've
already said, every tutorial on the web I could find uses absolute paths,
too, so the problem seems to be common, as is the work-around.  Therefore
please apply this patch (perhaps changing my comment to "cscope is broken
with relative paths, work around it via absolute paths").

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
