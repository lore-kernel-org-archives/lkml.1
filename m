Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbXLHABE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbXLHABE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXLHAAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:00:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:15368 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXLHAAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:00:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=lViKvyhEK/ybmb/g7CZ9nfkLXAAqDc3HhpT3EAQcel0iXcIO6OMrMJJCqVehuwVIJEXZxxC8166+7pQ+nKsNxYWCtt1s2/xegcEGiwHJRgLq8jMBbwPf0rkbqU90N13Ybd9oF/C+YOZjwu5wXok6Km9XuxtvqFvJ/xnIkVobTek=
Date: Sat, 8 Dec 2007 03:00:43 +0300
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Denis V. Lunev" <den@openvz.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Message-ID: <20071208000043.GC1951@martell.zuzino.mipt.ru>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com> <1197067918.10831.13.camel@heimdal.trondhjem.org> <20071207151444.af5d8e11.akpm@linux-foundation.org> <200712080043.29292.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712080043.29292.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 12:43:28AM +0100, Rafael J. Wysocki wrote:
> On Saturday, 8 of December 2007, Andrew Morton wrote:
> > On Fri, 07 Dec 2007 17:51:58 -0500
> > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > 
> > > On Fri, 2007-12-07 at 14:39 -0500, Shane wrote:
> > > > On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
> > > > ...
> > > > > Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> > > > > spots and check for other regressions.
> > > > 
> > > > Hmm, I installed a new kernel built from the same sources on the NFS
> > > > server. And now I don't see anything at all in the crossmnt dirs.
> > > > 
> > > > ls /dirA/dirB/dirC  --> zero output (empty dir)
> > > > 
> > > > Are there any other pending fixes?
> > > > 
> > > > Shane
> > > 
> > > You've probably fallen afoul of 
> > > 
> > >    http://bugzilla.kernel.org/show_bug.cgi?id=9504
> > > 
> > 
> > Yeah.
> > 
> > I have a tentative fix below but I can't seem to get Eric and Denis to get
> > a suitable fix nailed down.  It's urgent!
> 
> Well, how about asking Linus to revert commit
> 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416 altogether and starting over again?
> 
> It apparently causes more trouble than the issue it was supposed to fix.

I very much agree. ->shadow_proc is so ugly, so it's not funny anymore.
Adding such hook for proc part of networking _and_ for modules is just asking
for trouble as was demonstrated.
