Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYHMSQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYHMSQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYHMSQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:16:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHMSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:16:01 -0400
Date: Wed, 13 Aug 2008 20:17:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, arjan@infradead.org, alan@lxorguk.ukuu.org.uk,
       peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813181714.GL1366@one.firstfloor.org>
References: <1218645375.3540.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218645375.3540.71.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 12:36:15PM -0400, Eric Paris wrote:

I miss a clear answer to the question: is this 
supposed to protect against malware injected as root or not?

Assuming it wants to protect against root:

> think we hear claim more grandious things.  But from what I've seen they
> aren't the real deal.  Most of the security model descriptions that
> people on list want actually are framed under the belief that these
> products need to or attempt to completely block some class of attacks.
> They don't.  If you think they do you need to fix your frame of
> reference.  The only class of attacks this interface is supposed to
> address is those that can be found by scanning files.  This is NOT an
> LSM. 

But you need some LSM like protections to be able to protect the file
scanner? Like the block device or kernel memory protection.

> The real goal is to get files into to some userspace scanner and let
> them do whatever they want.  Remember, this isn't a new LSM.  The goal
> isn't to provide perfect security.  The goal isn't to stop already
> running malicious programs.  The one and only goal is to scan files.  We
> should not be considering timing attacks, we should not be considering
> processes actively trying to get around the system for small periods of
> time.  We should certainly not be considering root processes being able
> to sneak things by.  

This means you need significant LSM components simply to protect
the integrity of the file scanner against root. It's even 
unclear it's possible in the general case (e.g. X server doing
arbitary DMA and no IOMMU -- how do you protect the file scanner?)

> The idea is that a file exists on disk and we want
> some userspace program to give a best effort at scanning it.  Yes, we

Ok so you're implying it's ok to not protect against root?

In the later case that means that you don't have to scan anything
that only root can touch and you can trust file permissions,
which makes a lot of things easier.

I would suggest again to clarify this important point first. It has
significant impact on the whole design.

Personally I would think not protecting against root would be quite
limiting (e.g. it would mean that e.g. if some worm trojans rpms
people download then they wouldn't be caught because rpms are
installed as root), but on the other hand if you protect against
root you need most of selinux/aa/other lsm functionality simply
to guarantee the integrity of the scanner.  Also it has impact
on some apps, e.g. X server running as root would be usually out due to
the arbitary DMA issue. Also protect block devices could theoretically
have significant impact on some sysadmin tasks.

-Andi
