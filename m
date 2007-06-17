Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbXFQR2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbXFQR2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXFQR2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:28:07 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:41403 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbXFQR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:28:05 -0400
Date: Sun, 17 Jun 2007 10:28:02 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Wakko Warner <wakko@animx.eu.org>
cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <20070617132809.GB7806@animx.eu.org>
Message-ID: <Pine.LNX.4.64.0706171019490.24938@twinlark.arctic.org>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown> <20070616140857.GA4206@animx.eu.org>
 <Pine.LNX.4.64.0706161845180.24938@twinlark.arctic.org> <20070617132809.GB7806@animx.eu.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007, Wakko Warner wrote:

> dean gaudet wrote:
> > On Sat, 16 Jun 2007, Wakko Warner wrote:
> > 
> > > When I've had an unclean shutdown on one of my systems (10x 50gb raid5) it's
> > > always slowed the system down when booting up.  Quite significantly I must
> > > say.  I wait until I can login and change the rebuild max speed to slow it
> > > down while I'm using it.   But that is another thing.
> > 
> > i use an external write-intent bitmap on a raid1 to avoid this... you 
> > could use internal bitmap but that slows down i/o too much for my tastes.  
> > i also use an external xfs journal for the same reason.  2 disk raid1 for 
> > root/journal/bitmap, N disk raid5 for bulk storage.  no spindles in 
> > common.
> 
> I must remember this if I have to rebuild the array.  Although I'm
> considering moving to a hardware raid solution when I upgrade my storage.

you can do it without a rebuild -- that's in fact how i did it the first 
time.

to add an external bitmap:

mdadm --grow --bitmap /bitmapfile /dev/mdX

plus add "bitmap=/bitmapfile" to mdadm.conf... as in:

ARRAY /dev/md4 bitmap=/bitmap.md4 UUID=dbc3be0b:b5853930:a02e038c:13ba8cdc

you can also easily move an ext3 journal to an external journal with 
tune2fs (see man page).

if you use XFS it's a bit more of a challenge to convert from internal to 
external, but see this thread:

http://marc.theaimsgroup.com/?l=linux-xfs&m=106929781232520&w=2

i found that i had to do "sb 1", "sb 2", ..., "sb N" for all sb rather 
than just the "sb 0" that email instructed me to do.

-dean
