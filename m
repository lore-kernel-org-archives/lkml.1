Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYGCTns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYGCTns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYGCTnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:43:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYGCTnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:43:39 -0400
Message-ID: <486D2BC4.7000603@sandeen.net>
Date: Thu, 03 Jul 2008 14:43:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com
CC: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200806300122.48204.rjw@sisk.pl> <20080630061149.GA352@infradead.org> <200806302234.23887.rjw@sisk.pl>
In-Reply-To: <200806302234.23887.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

>>> I talked with Jens about it on a very general level, but it seems doable at
>>> first sight.
>> Why would you hack the blok layer when we already have a perfectly fine
>> facility to archive what you want?  freeze_bdev is there exactly for the
>> purpose to make the filesystem consistant on disk and then freeze all
>> I/O.
> 
> We tried that in the past and it didn't work very well due to some bad
> interactions with the md layer that we wanted to stay functional while we
> were saving the image.

Hm, details or a link?

> Also, do all of the supported filesystems implement this feature?


ext3, ext4, gfs2, jfs, reiserfs, xfs, all provide a write_super_lockfs
op, which is what freeze_bdev uses.  I think that the rest is generic,
for simpler filesystems.

-Eric
