Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYK2N6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYK2N6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 08:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYK2N6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 08:58:41 -0500
Received: from lazybastard.de ([212.112.238.170]:50909 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYK2N6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 08:58:40 -0500
Date: Sat, 29 Nov 2008 14:57:42 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Matthew Garrett <mjg@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081129135742.GC11959@logfs.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127170345.GA14991@infradead.org> <20081129002419.abfd2504.akpm@linux-foundation.org> <20081129130308.GX25548@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081129130308.GX25548@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 29 November 2008 06:03:08 -0700, Matthew Wilcox wrote:
> 
> That would imply that relatime could be different per-mountpoint.
> 
> I favour not making it configurable at all.

I guess some amount if configuration may be necessary.  If you go back
to the beginning of the thread...

On Wed, 26 November 2008 19:54:57 +0000, Matthew Garrett wrote:
> 
> Allow atime to be updated once per day even with relatime enabled.  This 
> lets utilities like tmpreaper (which deletes files based on last access 
> time) continue working.

...and check the tmpreaper manpage, you will notice that tmpreaper can
be configured as well.  So relatime has a default timeout of T and
tmpreaper is configured to delete files after 1/2 T (never mind what T
might be), the system breaks.  Guessing a value of T that is good enough
for everyone is a complicated business, so one configurable makes sense
imo.

One per mountpoint is rather silly, of course.

Jörn

-- 
Mundie uses a textbook tactic of manipulation: start with some
reasonable talk, and lead the audience to an unreasonable conclusion.
-- Bruce Perens
