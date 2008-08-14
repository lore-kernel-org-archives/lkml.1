Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYHNJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYHNJSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbYHNJSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:18:10 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:55820 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYHNJSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:18:08 -0400
In-Reply-To: <20080813112149.2fda0fa4@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Eric Paris <eparis@redhat.com>, greg@kroah.com, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-kernel-owner@vger.kernel.org,
       malware-list@lists.printk.net, peterz@infradead.org, riel@redhat.com,
       Theodore Tso <tytso@mit.edu>, viro@ZenIV.linux.org.uk
Subject: Re: TALPA - a threat model?  well sorta.
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Thu, 14 Aug 2008 10:18:02 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 14/08/2008 10:18:02,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 14/08/2008 10:18:02,
	Serialize complete at 14/08/2008 10:18:02,
	S/MIME Sign failed at 14/08/2008 10:18:02: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 14/08/2008 10:18:05,
	Serialize complete at 14/08/2008 10:18:05
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080814091810.12E8B2FE8B4@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote on 13/08/2008 19:21:49:

> > However, questions of which version of virus database was used to scan
> > a particular file should be stored outside of the filesystem, since
> 
> well I was assuming we only store this in memory (say in the inode) and
> just rescan the file if we destroy the in memory inode.
> I don't see the need for this to be persistent data; in fact I assume
> (Eric, please confirm) that this data is not *supposed* to be
> persistent.

Correct.

> > each product will have its own version namespace, and the questions of
> > what happens if a user switches from one version checker to another is
> 
> yes that's a hard question; what if you have 2 virus scanners active.
> 
> (they could register a version of the database with the kernel, and the
> in kernel version-cookie could be a hash of all registered versions I
> suppose.. if anything changes ever we just rehash and scan as if we
> have to do that)

It is in fact really simple with the proposed inode versioning approach. 
Any client which wants to invalidate the cache just needs to bump the 
global version number which will force a rescan on next access.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

