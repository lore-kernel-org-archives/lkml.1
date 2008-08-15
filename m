Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYHOUQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYHOUQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYHOUQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:16:36 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:32772 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYHOUQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:16:35 -0400
Date: Fri, 15 Aug 2008 16:16:22 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Rik van Riel <riel@redhat.com>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Paris <eparis@redhat.com>,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, hch@infradead.org, andi@firstfloor.org,
       viro@ZenIV.linux.org.uk, arjan@infradead.org
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080815201622.GD31584@cs.cmu.edu>
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	"Press, Jonathan" <Jonathan.Press@ca.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Paris <eparis@redhat.com>,
	peterz@infradead.org, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net, hch@infradead.org,
	andi@firstfloor.org, viro@ZenIV.linux.org.uk, arjan@infradead.org
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk> <1218646065.3540.75.camel@localhost.localdomain> <20080813173722.13c9c306@lxorguk.ukuu.org.uk> <1218646833.3540.82.camel@localhost.localdomain> <20080813205906.559d3f37@lxorguk.ukuu.org.uk> <2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com> <20080813173529.7069b5f1@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813173529.7069b5f1@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 05:35:29PM -0400, Rik van Riel wrote:
> On Wed, 13 Aug 2008 17:24:28 -0400
> "Press, Jonathan" <Jonathan.Press@ca.com> wrote:
> 
> > I may be missing something about your suggestion, but I don't see how
> > this would work.  Who does the chmod?
> 
> Chmod is also not a solution to the hierarchical storage (or incremental
> restore from backup) problem.
> 
> I believe we really do need the block-on-open.

Or use either the Fuse or Coda kernel modules and handle such requests
in userspace. With FUSE you should even be able to block on a per-page
granularity, Coda only has session semantics so it will only notify
userspace of the open and close events, while read and write and mmap
are passed directly to the underlying file.

Jan

