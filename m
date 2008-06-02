Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbYFBHNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbYFBHNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbYFBHNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:13:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:65529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYFBHNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:13:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Mon, 2 Jun 2008 09:12:49 +0200
User-Agent: KMail/1.9.9
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
References: <200805311737.58991.arnd@arndb.de> <200806012349.29538.arnd@arndb.de> <9785.1212374902@jrobl>
In-Reply-To: <9785.1212374902@jrobl>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-15?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-15?q?Y=2Ea=5E3zb?=)
 =?iso-8859-15?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-15?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806020912.49721.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19KRPCNAZRqtRtuRcin27BGplCRAyfGjYcyVyo
 3lR8jBKWKBFWRdFXGu4mko+Eszj9LbzSkpojHPzv4iIlTyRWVN
 BXISaPx4UU+CH75OjGx/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008, hooanon05@yahoo.co.jp wrote:
> While I don't have particular objection to your idea and approach to
> cramfs, I'd point out that modern LiveCDs tend to save their
> modifications to disk.

Sure, and I wasn't trying to address those of course. I have a rather
specific setup in mind myself, and I figured the same would be useful
for others as well, while we are waiting for a generic union mount
implementation in the mainline kernel.

> And AUFS did address all known problems. If there left something, please
> let me know.

Ok, I'm sorry for not having looked at it myself. I saw an older version
and assumed it was not going to improve much. I'll have another look
when I find the time. Unionfs was suffering from severe feature creep
(multiple writable branches, runtime branch modification), and aufs
seemed to add even more features instead of removing them.

Without reading either again, the top problems in unionfs at the time were:
* data inconsistency problems when simultaneously accessing the underlying
  fs and the union.
* duplication of dentry and inode data structures in the union wastes
  memory and cpu cycles.
* whiteouts are in the same namespace as regular files, so conflicts are
  possible.
* mounting a large number of aufs on top of each other eventually
  overflows the kernel stack, e.g. in readdir.
* allowing multiple writable branches (instead of just stacking
  one rw copy on a number of ro file systems) is confusing to the user
  and complicates the implementation a lot.

With the exception of the last two, I assumed that these were all
unfixable with a file system based approach (including the hypothetical
union-tmpfs). If you have addressed them, how?

	Arnd <><
