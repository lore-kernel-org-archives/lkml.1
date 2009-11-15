Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbZKOIPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbZKOIPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZKOIPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:15:53 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59543 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZKOIPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:15:52 -0500
Date: Sun, 15 Nov 2009 17:15:53 +0900 (JST)
Message-Id: <20091115.171553.84484979.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       paulus@samba.org
Subject: Re: [PATCH] perf tools: New function to parse string representing
 size in bytes
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091115080833.GC15432@elte.hu>
References: <1258257045-1363-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091115051155.GB5427@nowhere>
	<20091115080833.GC15432@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf tools: New function to parse string representing size in bytes
Date: Sun, 15 Nov 2009 09:08:33 +0100

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sun, Nov 15, 2009 at 12:50:45PM +0900, Hitoshi Mitake wrote:
> > > This patch modifies util/string.[ch] to add new function: bytesexp2int()
> > > to parse string representing size in bytes.
> > > 
> > > Below is the description of bytesexp2int().
> > > 
> > > Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
> > > and return its numeric value. (e.g. 268435456)
> > > 
> > > The parameter str is not changed before and after calling,
> > > but it changed temporally and internally for atoi().
> > > So type of str is char *, not const char *.
> > > 
> > > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > ---
> > >  tools/perf/util/string.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  tools/perf/util/string.h |    1 +
> > >  2 files changed, 90 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> > > index 04743d3..bbedb06 100644
> > > --- a/tools/perf/util/string.c
> > > +++ b/tools/perf/util/string.c
> > > @@ -1,4 +1,5 @@
> > >  #include <string.h>
> > > +#include <stdlib.h>
> > >  #include "string.h"
> > >  
> > >  static int hex(char ch)
> > > @@ -43,3 +44,91 @@ char *strxfrchar(char *s, char from, char to)
> > >  
> > >  	return s;
> > >  }
> > > +
> > > +static int digit(char ch)
> > > +{
> > > +	if ('0' <= ch && ch <= '9')
> > > +		return 1;
> > > +	return 0;
> > > +}
> > 
> > 
> > 
> > We have a "isdigit" macro in util.h already, despite the even already 
> > existing isdigit from the libc. I don't know why we have that. I guess 
> > it comes from git sources but I'm not sure why it has been 
> > reimplemented.
> 
> Git tends to be a lot saner when it comes to keeping library functions 
> sane, so i'd prefer if we kept and used the Git version.

Thanks Frederic and Ingo,
I rewrote the patch according to your advice.
So I'll send the new one in this thread.

   Hitoshi

