Return-Path: <linux-kernel-owner+w=401wt.eu-S932661AbXK2Q0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbXK2Q0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXK2Q0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:26:20 -0500
Received: from pmx2.sophos.com ([213.31.172.17]:53453 "EHLO pmx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932427AbXK2Q0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:26:18 -0500
In-Reply-To: <20071128183040.GW8181@ftp.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: Out of tree module using LSM
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5 November 30, 2005
Message-ID: <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
From: tvrtko.ursulin@sophos.com
Date: Thu, 29 Nov 2007 16:26:12 +0000
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.2FP1|January 10, 2007) at
 29/11/2007 16:26:15,
	Serialize complete at 29/11/2007 16:26:15
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote on 28/11/2007 18:30:40:

> On Wed, Nov 28, 2007 at 01:15:05PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > (Note that the concept has interesting implications in the other 
> direction as
> > well - rather than stopping you from reading a file that has 
> malware, you could
> > in theory write an anti-export package that would let you write 
> onto external
> > memory or outbound e-mail, but prevent the write if it was 
> corporate-sensitive
> > data, or whatever.
> 
> You _can_ _not_ do that.  If shared mapping gets dirtied, you have no 
way to
> intercept that.  At all.  Especially since the page stays mapped while 
it is
> written out, so the next modification can come when hardware had already
> started outbound DMA and there's no way to abort it, no matter what your
> external scanner would do.
> 
> Folks, really, that doesn't work.  At all.  You can intercept all system
> calls you want and it will not be enough to prevent the "bad" contents
> from hitting the disk.

On this level we are not talking about stopping bad stuff from hitting the 
disk. There is a lot simpler scenario how that can happen and that is via 
a dropper at which point it can be detected and reported when the file is 
closed. But more importantly further access to it can be blocked until 
appropriate actions are taken which also applies with your example, no? Is 
it possible to open for execute and have dirty mappings (or open for 
write) on a file at the same time?

> And if we are talking about the situation when files are written to in
> controlled way (i.e. we are not concerned with malware running on the 
box
> in question and just want to stop it from passing through mailsewer, 
etc.),
> then there's no damn need to play with LSM - just have e.g. coda with 
its
> commit-on-close and run the scanner on commit.  End of story.  Mind you,
> in such setups one would be much better off just having the mail server 
run
> the tests explicitly in the userland, along with the rest of anti-spam, 
etc.
> filters.

That is true for that scenario.

--
Tvrtko August Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."

Tel: 01235 559933
Web: www.sophos.com
Protecting business against viruses, spyware, spam and policy abuse


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

