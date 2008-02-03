Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbYBCNv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbYBCNv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 08:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYBCNvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 08:51:15 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:1377 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYBCNvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 08:51:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jq8339lQwB3OeQ+AnG6ClfR+hvgIedmc08Ogr67SpTAPGjFZ28QZPSg27Hzc+1uw1U5G5xxXHlkTZW2qn3zvaJCOqM9zMGuIOBpeFBYSpFKaeixVFr2Jp1zvPiCuuqhKsDD81MgGt/QJafMOG3wrJsZnaWUT5RbMtEmofatWxuY=
Message-ID: <2f11576a0802030551s53eeb7b3k450254f3d2cf9ab7@mail.gmail.com>
Date: Sun, 3 Feb 2008 22:51:10 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [RFC] Parallelize IO for e2fsck
Cc: "Theodore Tso" <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
       "David Chinner" <dgc@sgi.com>, "Valerie Henson" <val@vahconsulting.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Andreas Dilger" <adilger@clusterfs.com>,
       "Ric Wheeler" <ric@emc.com>, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080128200105.GA4719@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com>
	 <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
	 <20080121230041.GL3180@webber.adilger.int>
	 <20080122033830.GR155259@sgi.com>
	 <3673.1200975438@turing-police.cc.vt.edu>
	 <20080122070050.GM3180@webber.adilger.int>
	 <20080122144052.GC17804@mit.edu> <20080128193005.GC4032@ucw.cz>
	 <20080128195633.GB20528@mit.edu> <20080128200105.GA4719@ucw.cz>
X-Google-Sender-Auth: ad4115dc28aaaaa5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel

> > > As user pages are always in highmem, this should be easy to decide:
> > > only send SIGDANGER when highmem is full. (Yes, there are
> > > inodes/dentries/file descriptors in lowmem, but I doubt apps will
> > > respond to SIGDANGER by closing files).
> >
> > Good point; for a system with at least (say) 2GB of memory, that
> > definitely makes sense.  For a system with less than 768 megs of
> > memory (how quaint, but it wasn't that long ago this was a lot of
> > memory :-), there wouldn't *be* any memory in highmem at all....
>
> Ok, so it is 'send SIGDANGER when all zones are low', because user
> allocations can go from all zones (unless you have something really
> exotic, I'm not sure if that is true on huge NUMA  machines & similar).

thank you good point out.

to be honest, the zone awareness of current mem_notify is premature.
I think we need enhancement rss statistics to per zone rss.
but not implemented yet ;-)

and, unfortunately I have no highmem machine.
the mem_notify is not so tested on highmem machine.

if you help to test, I am very happy!
Thanks.
