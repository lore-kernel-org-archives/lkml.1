Return-Path: <linux-kernel-owner+w=401wt.eu-S1765318AbZDCNmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765318AbZDCNmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764982AbZDCNmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:42:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49793 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbZDCNmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:42:37 -0400
Date: Fri, 3 Apr 2009 14:42:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403134208.GB19774@srcf.ucam.org>
References: <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org> <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org> <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm> <20090403011953.GA10777@srcf.ucam.org> <alpine.DEB.1.10.0904021821120.28893@asgard.lang.hm> <20090403013603.GA10886@srcf.ucam.org> <alpine.DEB.1.10.0904021954080.30587@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904021954080.30587@asgard.lang.hm>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 08:08:36PM -0700, david@lang.hm wrote:
> On Fri, 3 Apr 2009, Matthew Garrett wrote:
> >Well, yes, the administrator could hate the user. They could achieve the
> >same affect by just LD_PRELOADING something that stubbed out fsync() and
> >inserted random data into every other write(). We generally trust that
> >admins won't do that.
> 
> then trust the admins to make a reasonable decision for or with the user 
> on this as well.

What a reasonable decision is here depends on what software the user is 
running. There simply isn't a reasonable default other than to allow 
fsync() to work. Changing requires auditing every single piece of code 
the user may run.

> >There's various circumstances in which it's beneficial. The difference
> >between an optimal algorithm for typical use and an optimal algorithm
> >for typical use where there's an fsync() every 5 minutes isn't actually
> >that great.
> 
> mixing some sub-threads a bit to combine thoughts
> 
> you object to calling something like this 'laptop mode'
> 
> Ted's statements about laptop mode indicate that he believes that it 
> delays writes for a configurable time rather than accelerating writes.

As I said, the code is pretty easy to read.

(snip)

> thoughts?

I've certainly got no objection to the addition of a mode that changes 
the behaviour of fsync() - personally I think it would be an error for 
almost anyone to use it, but that's really up to the individual 
situation. But it would have a different goal to the existing 
laptop-mode and so should have a different name in order to avoid 
confusion.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
