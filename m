Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbZDCABS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbZDCABS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZDCABH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:01:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40598 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZDCABG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:01:06 -0400
Date: Fri, 3 Apr 2009 01:00:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Ray Lee <ray-lk@madrabbit.org>, david@lang.hm,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403000039.GD9538@srcf.ucam.org>
References: <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <2c0942db0904021307w2c311dc2s9bf31c9ed3c1e6ba@mail.gmail.com> <49D5273B.60806@ursus.ath.cx> <20090402233806.GG9870@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402233806.GG9870@mit.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:38:06PM -0400, Theodore Tso wrote:

> What's been frustrating about this whole controversy is this implicit
> assumptions that users and applications should never change, and the
> filesystem should magically accomodate and Do The Right Thing.

This is the attitude that I have a significant problem with. Filesystems 
exist to serve applications. Without applications, there's no reason to 
have a filesystem. If a filesystem doesn't provide the behaviour that 
applications want then that filesystem has no reason to exist. The aim 
isn't to produce a platonically ideal filesystem. The aim is to produce 
a filesystem that behaves well given the applications that use it.

Disagreeing with the behaviour of applications is a perfectly sensible 
thing to do. However, it's something that should be done at the *start* 
of a filesystem development cycle. Getting agreement from a broad 
section of application developers means that you get to write a 
filesystem that embodies a different set of assumptions and everyone 
wins. Writing a filesystem and then bitching about application behaviour 
after it's been merged to mainline is just pathological.

> The problem is, this is what the application programmers are telling
> the filesystem developers.  They refuse to change their programs; and
> the features they want are sometimes mutually contradictory, or at
> least result in a overconstrained problem --- and then they throw the
> whole mess at the filesystem developers' feet and say, "you fix it!"

Which application developers did you speak to? Because, frankly, the 
majority of the ones I know felt that ext3 embodied the pony that they'd 
always dreamed of as a five year old. Stephen gave them that pony almost 
a decade ago and now you're trying to take it to the glue factory. I 
remember almost crying at that bit on Animal Farm, so I'm really not 
surprised that you're getting pushback here.

> I'm not saying the filesystems are blameless, but give us a little
> slack, guys; we NEED some help from the application developers here.

Then having a discussion with application developers over the 
expectations they can have would be a good first step. Just pointing at 
POSIX isn't good enough - POSIX allows a bunch of behaviours 
sufficiently pathological that a filesystem implementing them would be 
less useful than /dev/null. We need to have a worthwhile conversation 
about what guarantees Linux will provide above and beyond POSIX. The 
filesystem summit next week isn't going to be that conversation. Perhaps 
something to try at Plumbers?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
