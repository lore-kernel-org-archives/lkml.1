Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbZDCBb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbZDCBb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZDCBbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:31:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:41821 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZDCBbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:31:49 -0400
Date: Fri, 3 Apr 2009 03:31:46 +0200
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-ID: <20090403013146.GB23937@wotan.suse.de>
References: <20090310143718.GB15977@wotan.suse.de> <1236809477.30142.83.camel@nimitz> <20090312041334.GB1893@wotan.suse.de> <1237403623.8286.196.camel@nimitz> <20090402182210.GB17175@wotan.suse.de> <20090402184305.GI28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402184305.GI28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:43:05PM +0100, Al Viro wrote:
> On Thu, Apr 02, 2009 at 08:22:10PM +0200, Nick Piggin wrote:
> > On Wed, Mar 18, 2009 at 12:13:43PM -0700, Dave Hansen wrote:
> > > On Thu, 2009-03-12 at 05:13 +0100, Nick Piggin wrote: 
> > > > On Wed, Mar 11, 2009 at 03:11:17PM -0700, Dave Hansen wrote:
> > > > > I'm feeling a bit better about these, although I am still honestly quite
> > > > > afraid of the barriers.  I also didn't like all the #ifdefs much, but
> > > > > here's some help on that.
> > > > 
> > > > FWIW, we have this in suse kernels because page fault performance was
> > > > so bad compared with SLES10. mnt_want_write & co was I think the 2nd
> > > > biggest offender for file backed mappings (after pvops). I think we're
> > > > around parity again even with pvops.
> > > 
> > > Page faults themselves?  Which path was that from?
> > 
> > Yes. file_update_time.
> 
> FWIW, I'm not sure that this optimization is valid.  We might eventually
> want to go for "don't allow any new writers, remount r/o when existing
> ones expire" functionality, so nested mnt_want_write() might eventually
> be allowed to fail.

I guess then it would need another flag to check than checking
RDONLY (BECOMING_RDONLY or something)
