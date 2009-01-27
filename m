Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZA0L4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZA0L4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZA0L4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:56:16 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43560 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbZA0L4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:56:16 -0500
Date: Tue, 27 Jan 2009 06:55:52 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, kexec@lists.infradead.org, horms@verge.net.au
Subject: Re: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
Message-ID: <20090127115552.GA3898@hmsreliant.think-freely.org>
References: <20090119212127.GA13157@hmsreliant.think-freely.org> <20090120141551.GA5125@redhat.com> <20090120150958.GB18207@hmsreliant.think-freely.org> <20090120152255.GB5125@redhat.com> <20090127001211.f847ea5a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127001211.f847ea5a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 12:12:11AM -0800, Andrew Morton wrote:
> On Tue, 20 Jan 2009 10:22:56 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Tue, Jan 20, 2009 at 10:09:58AM -0500, Neil Horman wrote:
> > > On Tue, Jan 20, 2009 at 09:15:51AM -0500, Vivek Goyal wrote:
> > > > On Mon, Jan 19, 2009 at 04:21:27PM -0500, Neil Horman wrote:
> > > > > Hey all-
> > > > > 	It would be nice to be able to extract the dmesg log from a vmcore file
> > > > > without needing to keep the debug symbols for the running kernel handy all the
> > > > > time.  We have a facility to do this in /proc/vmcore.  This patch adds the
> > > > > log_buf and log_end symbols to the vmcoreinfo area so that tools (like
> > > > > makedumpfile) can easily extract the dmesg logs from a vmcore image.
> > > > > 
> > > > 
> > > > It would be nice to get dmesg log if debug symbols are not around. Can't
> > > > we use System.map for getting symbol addresses? vmcoreinfo had started
> > > > small and seems to be growing now. I am thinking down the line will making
> > > > use of System.map for such cases make sense?
> > > > 
> > > 
> > > System.map only include exported and public symbols.  log_buf and log_end are
> > > static, and not reported in the System.map.  Its a nice idea, but not
> > > comprehensive for everything in the kernel.
> > > 
> > > ><snip>
> > > > 
> > > > Will it be an issue if we make log_buf and log_end non static and directly
> > > > access these in kexec.c?
> > > > 
> > > I had considered that, but was a bit hesitant to do so, since it exposes the
> > > internal implementation of the dmesg buffer.  In the event someone disables
> > > CONFIG_PRINTK, thats just more code we need to ifdef.  With this implementation
> > > we just stub out the log_buf_setup function, and let that be that.  It seems
> > > more consice to me this way.
> > > 
> > 
> > Makes sense to me.
> > 
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> > 
> 
> I rewrote the title to
> 
> 	kexec: add dmesg log symbols to /proc/vmcoreinfo lists
> 
> it's nice to identify which subsystem is responsible for a patch.
> 
> I also did all the below.  Please check it.  (Is anyone else reading all
> this stuff??)
> 
> 
Hey Andrew-
	Yes, that all looks fine, thank.  I'm not sure of the advantage of an
inline over a #define in the event that CONFIG_PRINTK isn't defined, but its
fine with me either way.

Much appreciated!
Neil

> 
