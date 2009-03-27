Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZC0Dr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZC0Dr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZC0DrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:47:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59535 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZC0DrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:47:17 -0400
Date: Fri, 27 Mar 2009 03:47:05 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327034705.GA16888@srcf.ucam.org>
References: <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327032301.GN6239@mit.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 11:23:01PM -0400, Theodore Tso wrote:

> Yeah, well, it's caused by data=ordered, which is an ext3 unique
> thing; no other filesystem (or operating system) has such a feature.
> I'm beginning to wish we hadn't implemented it.  Yeah, it solved a
> security problem (which delayed allocation also solves), but it
> trained application programs to be careless about fsync(), and it's
> caused us so many other problems, including the fsync() and unrelated
> commit latency problems.

Oh, for the love of a whole range of mythological figures. ext3 didn't 
train application programmers that they could be careless about fsync(). 
It gave them functionality that they wanted, ie the ability to do things 
like rename a file over another one with the expectation that these 
operations would actually occur in the same order that they were 
generated. More to the point, it let them do this *without* having to 
call fsync(), resulting in a significant improvement in filesystem 
usability.

I'm utterly and screamingly bored of this "Blame userspace" attitude. 
The simple fact of the matter is that ext4 was designed without paying 
any attention to how the majority of applications behave. fsync() isn't 
the interface people want. ext3 demonstrated that a filesystem could be 
written that made life easier for application authors. Why on earth 
would anyone think that taking a step back by requiring fsync() in a 
wider range of circumstances was a good idea?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
