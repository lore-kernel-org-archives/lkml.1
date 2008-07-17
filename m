Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbYGQOOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbYGQOOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbYGQOOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:14:01 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:60520 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbYGQOOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:14:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAOTufkhMRKxB/2dsb2JhbACBWq56
Date: Thu, 17 Jul 2008 10:13:58 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       ltt-dev@lists.casi.polymtl.ca, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markers duplicate modpost entry
Message-ID: <20080717141358.GA22860@Krystal>
References: <20080715024754.GA26471@Krystal> <000001c8e7aa$b9548600$2bfd9200$@css.fujitsu.com> <20080717024550.GA22869@Krystal> <487ED503.2060503@oracle.com> <20080717070321.GB26035@Krystal> <20080717001613.8fe204df.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080717001613.8fe204df.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:10:49 up 42 days, 18:51,  4 users,  load average: 0.87, 0.85,
	0.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 17 Jul 2008 03:03:21 -0400 Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > When a kernel was rebuilt, the previous Module.markers was not cleared. It
> > caused markers with different format strings to appear as duplicates when a
> > markers was changed.
> > 
> > I merely merged the patches from Roland and Wenji here. It applies to
> > mainline (and is not intrusive, so will also apply to linux-next).
> 
> Is this fix needed in 2.6.26.x?  2.6.25.x?
> 

Yes, it's needed in 2.6.26.x and 2.6.25, but I doubt it is critical :
only needed for systemtap users which use markers and rebuild their
kernel after having changed a marker format string.

> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > From: Roland McGrath <roland@redhat dot com>
> > From: Wenji Huang <wenji.huang@oracle.com>
> > CC: akpm@linux-foundation.org
> 
> whoa, what's all that about?
> 
> Patches can only have one Author: in git, and we indicate that in
> emails by putting a From: line right at the top of the changelog. 
> (Additional credits can and should be mentioned in the changelog text
> of course).  When that From: line is missing we take the authorship
> info from the email headers.
> 
> So according to the above, this patch has three authors.  Geeze, even I
> can type faster than that!
> 

hehehe :)

> Who wrote it?
> 

I took the diffs Roland and Wenji sent in separate emails and created
this patch. They are the ones who actually identified the solution. So I
guess I should be the author, with credits to them, if they are ok with
that.

Mathieu


> > ---
> >  scripts/Makefile.modpost |    1 +
> >  scripts/mod/modpost.c    |    3 ++-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6-lttng/scripts/Makefile.modpost
> > ===================================================================
> > --- linux-2.6-lttng.orig/scripts/Makefile.modpost	2008-07-17 02:47:44.000000000 -0400
> > +++ linux-2.6-lttng/scripts/Makefile.modpost	2008-07-17 02:48:17.000000000 -0400
> > @@ -101,6 +101,7 @@ quiet_cmd_kernel-mod = MODPOST $@
> >        cmd_kernel-mod = $(modpost) $@
> >  
> >  vmlinux.o: FORCE
> > +	@rm -fr $(kernelmarkersfile)
> >  	$(call cmd,kernel-mod)
> >  
> >  # Declare generated files as targets for modpost
> > Index: linux-2.6-lttng/scripts/mod/modpost.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/scripts/mod/modpost.c	2008-07-17 02:49:33.000000000 -0400
> > +++ linux-2.6-lttng/scripts/mod/modpost.c	2008-07-17 02:50:10.000000000 -0400
> > @@ -1992,7 +1992,8 @@ static void read_markers(const char *fna
> >  			mod->skip = 1;
> >  		}
> >  
> > -		add_marker(mod, marker, fmt);
> > +		if (!mod->skip)
> > +			add_marker(mod, marker, fmt);
> >  	}
> >  	return;
> >  fail:
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
