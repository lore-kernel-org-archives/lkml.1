Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZLANGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZLANGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZLANGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:06:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:60453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZLANGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:06:12 -0500
Message-ID: <4B1514C8.3000505@suse.cz>
Date: Tue, 01 Dec 2009 14:06:16 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: specify absolute paths for cscope
References: <1259238852-21214-1-git-send-email-daniel.vetter@ffwll.ch> <4B13FD4B.5080805@suse.cz> <20091130181109.GA19614@merkur.ravnborg.org> <20091201094222.GC9177@viiv.ffwll.ch>
In-Reply-To: <20091201094222.GC9177@viiv.ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.12.2009 10:42, Daniel Vetter wrote:
> I've just tried to use cscope with a working directory not equal to the
> directory where cscope.out resides:
> 
> $ cscope -d -f src/cscope.out
> 
> It can't handle relative paths. When I try to open a file (via a
> reference) from within cscope, it calls up vim with the wrong path.  So I
> think this is a fundamental cscope bug (and not a vim problem).  As I've
> already said, every tutorial on the web I could find uses absolute paths,
> too, so the problem seems to be common, as is the work-around.  Therefore
> please apply this patch (perhaps changing my comment to "cscope is broken
> with relative paths, work around it via absolute paths").

OK, you convinced me. I applied it to for-next, with a minor edit to fix
O= builds (the tree variable is an absolute path already):
http://repo.or.cz/w/linux-kbuild.git/commitdiff/037aaae02ecf3925b843316868743c755d73fb22
I hope the next guy won't come and complain the he moved linux-2.6.xy to
linux-2.6.xy.orig and cscope stopped working :).


On 30.11.2009 19:11, Sam Ravnborg wrote:
> For tags I recall we fall back to absolute path only for O=... builds.
> This made the tags file considerably smaller for a non O=.. build
> thus speeding up the search.
> 
> So unconditionally using absolute paths for cscope may have drawbacks.

I tried it and this part seems OK. Generating the database took more or
less the same time, cscope.out grew by less than 1% and opening cscope
and running a query for 'printk' slowed down by about 8%, I think that's
bearable.

Michal
