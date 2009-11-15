Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbZKOIIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbZKOIIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZKOIIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:08:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZKOIIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:08:44 -0500
Date: Sun, 15 Nov 2009 09:08:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: New function to parse string representing
 size in bytes
Message-ID: <20091115080833.GC15432@elte.hu>
References: <1258257045-1363-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20091115051155.GB5427@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091115051155.GB5427@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sun, Nov 15, 2009 at 12:50:45PM +0900, Hitoshi Mitake wrote:
> > This patch modifies util/string.[ch] to add new function: bytesexp2int()
> > to parse string representing size in bytes.
> > 
> > Below is the description of bytesexp2int().
> > 
> > Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
> > and return its numeric value. (e.g. 268435456)
> > 
> > The parameter str is not changed before and after calling,
> > but it changed temporally and internally for atoi().
> > So type of str is char *, not const char *.
> > 
> > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  tools/perf/util/string.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/string.h |    1 +
> >  2 files changed, 90 insertions(+), 0 deletions(-)
> > 
> > diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> > index 04743d3..bbedb06 100644
> > --- a/tools/perf/util/string.c
> > +++ b/tools/perf/util/string.c
> > @@ -1,4 +1,5 @@
> >  #include <string.h>
> > +#include <stdlib.h>
> >  #include "string.h"
> >  
> >  static int hex(char ch)
> > @@ -43,3 +44,91 @@ char *strxfrchar(char *s, char from, char to)
> >  
> >  	return s;
> >  }
> > +
> > +static int digit(char ch)
> > +{
> > +	if ('0' <= ch && ch <= '9')
> > +		return 1;
> > +	return 0;
> > +}
> 
> 
> 
> We have a "isdigit" macro in util.h already, despite the even already 
> existing isdigit from the libc. I don't know why we have that. I guess 
> it comes from git sources but I'm not sure why it has been 
> reimplemented.

Git tends to be a lot saner when it comes to keeping library functions 
sane, so i'd prefer if we kept and used the Git version.

Thanks,

	Ingo
