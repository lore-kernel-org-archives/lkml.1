Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbXFUFZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbXFUFZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 01:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXFUFZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 01:25:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:10502 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXFUFZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 01:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VsgRVyHNfCoNa+4OTOrgd6wIvTYXjmSjsYVlnksROISVEJ4ekKWIqGTg6SVExX+YcEsJBLl85j0PgVrtf/diVG0/6gFlo8IjeEN1LlGwePVVYx8Cun4j7fsOMHglVeNxfRX0gi/Qs/oT2xgG1fBS1kKj/8VH0raVjBPtMcavjhU=
Message-ID: <344eb09a0706202225i6743159x68e3a5416850eed3@mail.gmail.com>
Date: Thu, 21 Jun 2007 10:55:45 +0530
From: "Bharata B Rao" <bharata.rao@gmail.com>
To: "Erez Zadok" <ezk@cs.sunysb.edu>
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
Cc: "Jan Blunck" <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       jsipek@ic.sunysb.edu, bharata@linux.vnet.ibm.com
In-Reply-To: <200706201728.l5KHS9hj029372@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f5al1i$foi$1@sea.gmane.org>
	 <200706201728.l5KHS9hj029372@agora.fsl.cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> In message <f5al1i$foi$1@sea.gmane.org>, Jan Blunck writes:
> > On Tue, 19 Jun 2007 22:59:51 -0700, Arjan van de Ven wrote:
> >
> > > first of all I'm happy to see that people are still working on unionfs;
> > > I'd love to have functionality like this show up in Linux.
> >
> > This has nothing to do with unionfs. This is about doing a VFS based
> > approach to union mounts. Unification is a name-based construct so it
> > belongs into VFS and not into a separate file system.
>
> Jan, while I agree with you in principle that unification is a VFS-level
> namespace construct, I disagree with you that unioning doesn't belong in a
> separate f/s.
>
> As someone whose group developed three generations of the stackable file
> system Unionfs (see http://unionfs.filesystems.org/), I can tell you from my
> experience and the experience of numerous users, that the devil is the
> details -- or the so-called orthogonal issues.  To get a fully working
> unioning implementation, one that the many current users of Unionfs could
> use, you'll have to deal with many issues and corner cases: cache coherency,
> inode persistency (and network f/s exports), copyups, whiteouts and opaque
> dirs, how to deal with "odd" file systems which don't support native
> whiteouts and such, directory reading (seekdir), and more.  Our third
> generation Unionfs, the one with On-Disk Format (ODF), handles all of these.
> Rather than reproduce all that discussion here, I'll point people to read
> more info here: <http://www.filesystems.org/unionfs-odf.txt>

Erez, thanks, will definetely have to look at that to understand how
unionfs is addressing all these corner cases.

Though I don't understand all the issues involved with cache coherency
atm, one of the things you said during unionfs 2.0 release is that it
is now possible to make modifications to the lower layer directly and
they will be visible from the union. Note that since we do unioning at
VFS layer, we don't explicitly address this. Direct
modifications/additions to the lower layer will automatically get
reflected in the union. Anyway before commenting anything more on
this, let me get back and study the coherency issues more closely :)

>
> So, to have a fully usable union mounts implementation, you're going to have
> to support a lot of existing features; but if you were to support them all
> at the VFS level, you will have bloated the VFS considerably with stuff that
> many would argue does not belong in the VFS.

Talking about copyup and whiteout at VFS layer, we have already
demonstrated what complexity it takes to have these within VFS. Please
take a look at the copyup and whiteout patches in our previous
releases at:

http://lkml.org/lkml/2007/4/17/150
http://lkml.org/lkml/2007/5/14/69

Or may be wait till I clean all those up to work with the new union
new stack infrastructure which I have posted here.

Regards,
Bharata.
-- 
"Men come and go but mountains remain" -- Ruskin Bond.
