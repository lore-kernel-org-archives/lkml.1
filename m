Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYK2S5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYK2S5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 13:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYK2S5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 13:57:07 -0500
Received: from mail2.shareable.org ([80.68.89.115]:47642 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYK2S5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 13:57:06 -0500
Date: Sat, 29 Nov 2008 18:56:45 +0000
From: Jamie Lokier <jamie@shareable.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Matthew Garrett <mjg@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081129185645.GA20194@shareable.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127170345.GA14991@infradead.org> <20081129002419.abfd2504.akpm@linux-foundation.org> <20081129130308.GX25548@parisc-linux.org> <20081129135742.GC11959@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081129135742.GC11959@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> ...and check the tmpreaper manpage, you will notice that tmpreaper can
> be configured as well.  So relatime has a default timeout of T and
> tmpreaper is configured to delete files after 1/2 T (never mind what T
> might be), the system breaks.  Guessing a value of T that is good enough
> for everyone is a complicated business, so one configurable makes sense
> imo.
>
> One per mountpoint is rather silly, of course.

If it's configurable at all for tmpreaper (or similar), it should work
the same for tmpreaper in virtual machine containers.  (Same as,
e.g. utsname is different in containers).  If not now, someone will
have to patch it later.  Each VM runs it's own tmpreaper, configured
usually by separate people.

It's probably simpler to make it per-mountpoint than a virtualised global.

I don't see why there is an objection to per-mountpoint.
Andrew Morton's syntax: mount /dev/foo /mnt/bar -o relatime=86400
looks natural to me.

-- Jamie
