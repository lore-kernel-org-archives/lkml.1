Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYHNASU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYHNASU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYHNASL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:18:11 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:28446 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYHNASK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=td0C0c3olCgxzf9x7HM5dw9Ey7NhYyElw90qzQeOVlb8WXPEJ0FrZInwIi4Lyd3WlL
         MO0+n5UK5wlQYAJWSWCNefHon+Lw/tpAJc3N8we74COH3qI3a1h/hHpmcQcpOdjhdIpK
         EVQOCzJ7N6CjsPl9slaLMx6krdK/0OyBn5rSU=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: TALPA - a threat model?  well sorta.
Date: Thu, 14 Aug 2008 03:18:00 +0300
User-Agent: KMail/1.9.9
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, riel@redhat.com, greg@kroah.com,
       tytso@mit.edu, viro@zeniv.linux.org.uk, arjan@infradead.org,
       alan@lxorguk.ukuu.org.uk, peterz@infradead.org, hch@infradead.org
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813181714.GL1366@one.firstfloor.org>
In-Reply-To: <20080813181714.GL1366@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808140318.00740.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008, Andi Kleen wrote:
> On Wed, Aug 13, 2008 at 12:36:15PM -0400, Eric Paris wrote:
>
> I miss a clear answer to the question: is this
> supposed to protect against malware injected as root or not?

I honestly don't think we should worry about root. Sure, if the AV scanner 
happens to catch something (as a consequence of it's implementation), then 
very well. But designing an antimalware solution which assumes the root is 
compromised will throw us into security talks for years and I don't think 
we'll live to hear the end of them.

We should focus on the regular users and fix (if needed) the current userland 
apps (ie. the ones that need root access to do their job). For anymore than 
that we'll need a super user that supervises root. And then another one.

> Assuming it wants to protect against root:
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
> installed as root)

If GPG signatures don't work, then please fix the rpm design and if the user 
willingly installs a .rpm which is not signed (not from a known trusted host) 
and somehow doges the basic antimalware scanner, then too bad. We've done all 
we could.

> , but on the other hand if you protect against 
> root you need most of selinux/aa/other lsm functionality simply
> to guarantee the integrity of the scanner.  Also it has impact
> on some apps, e.g. X server running as root would be usually out due to
> the arbitary DMA issue. Also protect block devices could theoretically
> have significant impact on some sysadmin tasks.

I think we need to define the 'desktop user' and provide a decent protection 
mechanism for his common activities (edit documents, listen music, navigate 
the web, see movies, run scripts which change the IM status etc). For the 
rest, there are two possibilities:
    1. education (_extremely_ important);
    2. SELinux (or similar);

I don't think there will ever be an AV product using the marketing line: "it 
allows you to run your favorite rootkit and enjoy the pretty text it shows, 
with no worries".

In conclusion: everything AV related should stop at the user root. Popular 
distro-s already provide a way to do your daily office tasks without super 
user rights, which _is_ the correct thing to do.

-- 
Mihai Donțu
