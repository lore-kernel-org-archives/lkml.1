Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbXLHAQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbXLHAQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXLHAPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:15:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbXLHAPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:15:52 -0500
Date: Fri, 7 Dec 2007 16:15:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: rjw@sisk.pl, trond.myklebust@fys.uio.no, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org,
       ebiederm@xmission.com, den@openvz.org
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Message-Id: <20071207161508.afe8fdf1.akpm@linux-foundation.org>
In-Reply-To: <20071208000043.GC1951@martell.zuzino.mipt.ru>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	<1197067918.10831.13.camel@heimdal.trondhjem.org>
	<20071207151444.af5d8e11.akpm@linux-foundation.org>
	<200712080043.29292.rjw@sisk.pl>
	<20071208000043.GC1951@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 03:00:43 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sat, Dec 08, 2007 at 12:43:28AM +0100, Rafael J. Wysocki wrote:
> > On Saturday, 8 of December 2007, Andrew Morton wrote:
> > > On Fri, 07 Dec 2007 17:51:58 -0500
> > > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > 
> > > > 
> > > > On Fri, 2007-12-07 at 14:39 -0500, Shane wrote:
> > > > > On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
> > > > > ...
> > > > > > Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> > > > > > spots and check for other regressions.
> > > > > 
> > > > > Hmm, I installed a new kernel built from the same sources on the NFS
> > > > > server. And now I don't see anything at all in the crossmnt dirs.
> > > > > 
> > > > > ls /dirA/dirB/dirC  --> zero output (empty dir)
> > > > > 
> > > > > Are there any other pending fixes?
> > > > > 
> > > > > Shane
> > > > 
> > > > You've probably fallen afoul of 
> > > > 
> > > >    http://bugzilla.kernel.org/show_bug.cgi?id=9504
> > > > 
> > > 
> > > Yeah.
> > > 
> > > I have a tentative fix below but I can't seem to get Eric and Denis to get
> > > a suitable fix nailed down.  It's urgent!
> > 
> > Well, how about asking Linus to revert commit
> > 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416 altogether and starting over again?
> > 
> > It apparently causes more trouble than the issue it was supposed to fix.
> 
> I very much agree. ->shadow_proc is so ugly, so it's not funny anymore.
> Adding such hook for proc part of networking _and_ for modules is just asking
> for trouble as was demonstrated.

OK, perhaps a revert is the best thing to do here.  I don't think anyone
will be expecting fully finalised and robust netns support in 2.6.24.

Eric?
