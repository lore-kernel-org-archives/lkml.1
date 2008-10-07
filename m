Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYJGPLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYJGPLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYJGPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:10:55 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:51919 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYJGPKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:10:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQFAB8Z60hMQWq+/2dsb2JhbACBcrxxgWo
Date: Tue, 7 Oct 2008 11:10:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       systemtap@sourceware.org
Subject: Re: [PATCH] markers: fix missing modpost entry in Module.markers
Message-ID: <20081007151052.GC31970@Krystal>
References: <48EB032B.3070200@cn.fujitsu.com> <20081007154401.5A59.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48EB3542.2060306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48EB3542.2060306@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:06:45 up 124 days, 19:47,  8 users,  load average: 1.79, 0.72,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

I tried to fix it in a way that would still not duplicate marker
entries, which is what the patch we are trying to repair was supposed to
do. The patch you propose here seems to go back to the old behavior
where we can have duplicate marker entries. I did not verify extensively
that my new patch does not duplicate marker entries though, but I tried
to follow the logic of your original patch.

Mathieu

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> KOSAKI Motohiro wrote:
> > Hi Lai
> > 
> > Have you seen "Markers in (non-module) kernel code?" thread?
> > I think this patch and that patch treat the same issue.
> > 
> 
> I didn't notice that thread.
> 
> > In addition, I think mathieu's patch is better.
> 
> I greed with you, Mathieu's patch is better.
> 
> Thanks.
> 
> > So, Could I hear your opinition for that?
> > 
> > 
> >> commit d35cb360c29956510b2fe1a953bd4968536f7216 brought a bug.
> >> marker points compiled in vmlinux are missing in Module.markers.
> >>
> >> # cat Module.markers
> >> subsystem_event samples/markers/marker-example  integer %d string %s
> >> subsystem_eventb        samples/markers/marker-example
> >>
> >> # stap -e 'probe kernel.mark("core_marker_format"){} '
> >> semantic error: no match while resolving probe point kernel.mark("core_marker_format")
> >> semantic error: no probes found
> >> Pass 2: analysis failed.  Try again with more '-v' (verbose) options.
> >>
> >> This patch revert a part of d35cb360c29956510b2fe1a953bd4968536f7216.
> >> Other parts have fixed duplicate modpost entry bug.
> >>
> >>
> >> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >> ---
> >> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> >> index 418cd7d..3509142 100644
> >> --- a/scripts/mod/modpost.c
> >> +++ b/scripts/mod/modpost.c
> >> @@ -1992,8 +1992,7 @@ static void read_markers(const char *fname)
> >>  			mod->skip = 1;
> >>  		}
> >>  
> >> -		if (!mod->skip)
> >> -			add_marker(mod, marker, fmt);
> >> +		add_marker(mod, marker, fmt);
> >>  	}
> >>  	return;
> >>  fail:
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> > 
> > 
> > 
> > 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
