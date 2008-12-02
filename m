Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYLBTL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYLBTL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYLBTLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:11:49 -0500
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3504 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbYLBTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:11:48 -0500
Date: Tue, 2 Dec 2008 20:10:42 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
       mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081202191038.GE29091@vanheusden.com>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202163720.GB18162@mit.edu>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue Dec  2 21:33:29 CET 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If disk looses data after acknowledging the write, all hope is lost.
> > Else I expect filesystem to preserve data I successfully synced.
> >      (In the b-tree split failed case I'd expect transaction commit to
> >      fail because new data could not be weitten; at that point
> >      disk+journal should still contain all the data needed for
> >      recovery of synced/old files, right?)
> 
> Not necessarily.  For filesystems that do logical journalling (i.e.,
> xfs, jfs, et. al), the only thing written in the journal is the
> logical change (i.e., "new dir entry 'file_that_causes_the_node_split'").

> The transaction commits *first*, and then the filesystem tries to
> write update the filesystem with the change, and it's only then that
> the write fails.  Data can very easily get lost.

> Even for ext3/ext4 which is doing physical journalling, it's still the

So do I understand this right that ext3/4 are more robust?


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
