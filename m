Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYHGRYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYHGRYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYHGRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:23:56 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:26975 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYHGRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:23:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=dUK3FhszG/HNIMWbvV0tFNaxL3iXrGMeuJDzxq5YS5aSUJt7G8w9vTwGWEyr8rb8jF
         WEbeiKR99reehw0sATJlBv+kD4nO6rwuLOg2bSgZnu2EJfEjkYce3byGFX2GPKTb9c8e
         n3DK0c+L1ht6ejOpCa5JJfE5hE6vcmxJClNEI=
Message-ID: <3ae3aa420808071023i5263600bo8b8627194941d8f3@mail.gmail.com>
Date: Thu, 7 Aug 2008 12:23:53 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <yq17iasg4k3.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	 <18581.6873.353028.695909@stoffel.org>
	 <3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
	 <20080803231628.1361b75f@lxorguk.ukuu.org.uk>
	 <3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com>
	 <20080805182119.75913fa3@lxorguk.ukuu.org.uk>
	 <3ae3aa420808061433i3d90c3dcgfb40d953da2941c8@mail.gmail.com>
	 <yq1fxphfs2y.fsf@sermon.lab.mkp.net>
	 <3ae3aa420808062132x52860092p9dee56705ba99a3@mail.gmail.com>
	 <yq17iasg4k3.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/7 Martin K. Petersen <martin.petersen@oracle.com>:

> Linas> Thus, a "tactical" solution seems to be pure-software
> Linas> check-summing in a kernel device-mapper module, performance be
> Linas> damned.
>
> What I don't understand is why you are so focused on fixing this at
> the RAID level.  I think your time would be better spent contributing
> to btrfs which gives you checksums and redundancy on consumer grade
> hardware today.  It's is only a few months away from GA.  So why not
> implement scrubbing in btrfs instead of spending time on a kludgy
> device mapper module with crappy performance?

Let me count the ways:
-- Time is an important consideration; I'd do this at home,
   spare-time, sandwiched between my formal commitments.
-- The device mapper interfaces are modular enough, and
   there are enough other device-mapper modules to serve
   as example code, that I could probably knock off the basic
    function in less  than a week, and then spend a few months
   polishing and enhancing at leisure.
-- Learning the in's and out's of btrfs would take more than
   a week.
-- Timeliness, modularity -- suppose I am pressed for time,
   and it takes me 6 months to develop a dm  module. I am
   pretty sure that the api's won't change out from under me,
   an my patches will still apply. By contrast, btrfs will likely
   undergo major changes by then, so slow-moving patches
   would likely be rotten/superceeded by then.
-- I'm architecturally conservative. Looking at the btrfs page
   does not make me comfortable: it seems to have a do-it-all
   set of goals. When I was younger, I created some do-it-all
   projects, and found that 1) the community was never as
   excited as I was, and 2) the list of desired features was
   overwhelmingly large, which means most didn't get done,
   and most of the rest were little more than proof-of-concept.
   My gut-sense, irrational vibe from the btrfs page is that its
   over-reaching -- examples of over-reaching projects that
   got in trouble were evms and reiserfs -- and so wait-n-see
   is my prudent response.
-- By contrast, raid+lvm already does most of what I need;
    I'd be happier seeing a project that leverages the existing
    raid+lvm infrastructure than one that fundamentally
    rethinks/redesigns everything. Nothing wrong with
    fundamental architectural re-thinks; its just that they're
    much riskier.

I dunno, I'm not even sure I have the time to do a dm module
I'm still tossing around the idea.

--linas
