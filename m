Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbZFOQaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbZFOQaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763454AbZFOQal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:30:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49120 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763571AbZFOQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:30:40 -0400
Date: Mon, 15 Jun 2009 12:30:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Daney <ddaney@caviumnetworks.com>
cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Wang Liming <liming.wang@windriver.com>,
       Wu Zhangjin <wuzj@lemote.com>, Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] filter local function prefixed by $L
In-Reply-To: <4A366FF7.2010206@caviumnetworks.com>
Message-ID: <alpine.DEB.2.00.0906151214160.30161@gandalf.stny.rr.com>
References: <cover.1244994151.git.wuzj@lemote.com> <d0983eb71d7517d0e536352f3288e995abbb0e07.1244994151.git.wuzj@lemote.com> <4A366FF7.2010206@caviumnetworks.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 15 Jun 2009, David Daney wrote:

> Wu Zhangjin wrote:
> > From: Wu Zhangjin <wuzj@lemote.com>
> > 
> > this patch fixed the warning as following:
> > 
> > mipsel-linux-gnu-objcopy: 'fs/proc/.tmp_gl_devices.o': No such file
> > mipsel-linux-gnu-ld: fs/proc/.tmp_gl_devices.o: No such file: No such
> > file or directory
> > rm: cannot remove `fs/proc/.tmp_gl_devices.o': No such file or directory
> > rm: cannot remove `fs/proc/.tmp_mx_devices.o': No such file or directory
> > 
> > the real reason of above warning is that the $Lxx local functions will
> > be treated as global symbols, so, should be filtered.
> > 
> > Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
> > ---
> >  scripts/recordmcount.pl |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > index 533d3bf..542cb04 100755
> > --- a/scripts/recordmcount.pl
> > +++ b/scripts/recordmcount.pl
> > @@ -343,6 +343,10 @@ sub update_funcs
> >  	if (!$use_locals) {
> >  	    return;
> >  	}
> > +	# filter $LXXX tags
> > +	if ("$ref_func" =~ m/\$L/) {
> > +		return;
> > +	}
> 
> Certainly this is true for mips.  I doubt it is for all architectures targed
> by Linux.

Yes, that should probably go into a mips only change. Unless you can 
reproduce it on all other archs, or at least x86.

You could also do this in the function_regex variable.

 "^([0-9a-fA-F]+)\\s+<(.|[^\$]L.*?|\$[^L].*?|[^\$][^L].*?)>:"

There may even be a better way, but I'm not in the mood to look it up ;-)

-- Steve

