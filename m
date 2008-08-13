Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYHMS6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYHMS6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYHMS6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:58:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYHMS6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:58:09 -0400
Subject: Re: TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       riel@redhat.com, greg@kroah.com, tytso@mit.edu, viro@ZenIV.linux.org.uk,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, peterz@infradead.org,
       hch@infradead.org
In-Reply-To: <20080813181714.GL1366@one.firstfloor.org>
References: <1218645375.3540.71.camel@localhost.localdomain>
	 <20080813181714.GL1366@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 14:40:11 -0400
Message-Id: <1218652811.3540.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 20:17 +0200, Andi Kleen wrote:
> On Wed, Aug 13, 2008 at 12:36:15PM -0400, Eric Paris wrote:
> 
> I miss a clear answer to the question: is this 
> supposed to protect against malware injected as root or not?

I thought I had summed that up.  We are not interested in providing
protections against maliciously attacking programs be they root or not.
We are interested in scanning files read and written by root.  We are
especially interested in programs run by root.

yum (as root) downloads trojan.rpm from youareanidiot.repo.  We aren't
worried about yum maliciously attacking the system.  What's going to
happen is that the scanner is going to scan the trojan.rpm when yum
calls rpm and rpm is going to be denied access to that file.  Doesn't
matter how you download it, its going to get scanned when you try to
exec it.

Stop thinking this is an LSM or as a new security model.  It's a file
scanner and "it ain't perfect security."  But its very useful and
practical.  If some malicious root application wants to turn it off it
can and I make no claims otherwise.  This isn't supposed to help once
root has been subverted, you've already lost as you admit, its supposed
to help keep root form getting subverted.

-Eric
> 
> > think we hear claim more grandious things.  But from what I've seen they
> > aren't the real deal.  Most of the security model descriptions that
> > people on list want actually are framed under the belief that these
> > products need to or attempt to completely block some class of attacks.
> > They don't.  If you think they do you need to fix your frame of
> > reference.  The only class of attacks this interface is supposed to
> > address is those that can be found by scanning files.  This is NOT an
> > LSM. 
> 
> But you need some LSM like protections to be able to protect the file
> scanner? Like the block device or kernel memory protection.
> 
> > The real goal is to get files into to some userspace scanner and let
> > them do whatever they want.  Remember, this isn't a new LSM.  The goal
> > isn't to provide perfect security.  The goal isn't to stop already
> > running malicious programs.  The one and only goal is to scan files.  We
> > should not be considering timing attacks, we should not be considering
> > processes actively trying to get around the system for small periods of
> > time.  We should certainly not be considering root processes being able
> > to sneak things by.  
> 
> This means you need significant LSM components simply to protect
> the integrity of the file scanner against root. It's even 
> unclear it's possible in the general case (e.g. X server doing
> arbitary DMA and no IOMMU -- how do you protect the file scanner?)
> 
> > The idea is that a file exists on disk and we want
> > some userspace program to give a best effort at scanning it.  Yes, we
> 
> Ok so you're implying it's ok to not protect against root?
> 
> In the later case that means that you don't have to scan anything
> that only root can touch and you can trust file permissions,
> which makes a lot of things easier.
> 
> I would suggest again to clarify this important point first. It has
> significant impact on the whole design.
> 
> Personally I would think not protecting against root would be quite
> limiting (e.g. it would mean that e.g. if some worm trojans rpms
> people download then they wouldn't be caught because rpms are
> installed as root), but on the other hand if you protect against
> root you need most of selinux/aa/other lsm functionality simply
> to guarantee the integrity of the scanner.  Also it has impact
> on some apps, e.g. X server running as root would be usually out due to
> the arbitary DMA issue. Also protect block devices could theoretically
> have significant impact on some sysadmin tasks.
> 
> -Andi

