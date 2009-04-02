Return-Path: <linux-kernel-owner+w=401wt.eu-S1751262AbZDBShm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbZDBShm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZDBSh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:37:29 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44820 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524AbZDBSh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:37:28 -0400
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090402182210.GB17175@wotan.suse.de>
References: <20090310143718.GB15977@wotan.suse.de>
	 <1236809477.30142.83.camel@nimitz> <20090312041334.GB1893@wotan.suse.de>
	 <1237403623.8286.196.camel@nimitz>  <20090402182210.GB17175@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 11:37:20 -0700
Message-Id: <1238697440.8846.46.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:22 +0200, Nick Piggin wrote:
> On Wed, Mar 18, 2009 at 12:13:43PM -0700, Dave Hansen wrote:
> > On Thu, 2009-03-12 at 05:13 +0100, Nick Piggin wrote: 
> > > On Wed, Mar 11, 2009 at 03:11:17PM -0700, Dave Hansen wrote:
> > > > I'm feeling a bit better about these, although I am still honestly quite
> > > > afraid of the barriers.  I also didn't like all the #ifdefs much, but
> > > > here's some help on that.
> > > 
> > > FWIW, we have this in suse kernels because page fault performance was
> > > so bad compared with SLES10. mnt_want_write & co was I think the 2nd
> > > biggest offender for file backed mappings (after pvops). I think we're
> > > around parity again even with pvops.
> > 
> > Page faults themselves?  Which path was that from?
> 
> Yes. file_update_time.

We should be able to use your mnt_clone_write() optimization separate
from the mnt_want_write() speedup here, right?  

-- Dave

