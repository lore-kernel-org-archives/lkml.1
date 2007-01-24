Return-Path: <linux-kernel-owner+w=401wt.eu-S965613AbXAXCDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613AbXAXCDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965615AbXAXCDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:03:12 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:53767 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965613AbXAXCDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:03:11 -0500
X-Originating-Ip: 74.109.98.130
Date: Tue, 23 Jan 2007 21:02:55 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Oleg Verych <olecom@flower.upol.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: identifying CONFIG variable typoes in the source tree
In-Reply-To: <slrnerd7e8.e7s.olecom@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0701232056040.7737@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701231559090.3014@CPE00045a9c397f-CM001225dbafb6>
 <slrnerd7e8.e7s.olecom@flower.upol.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-504790104-1169604174=:7739"
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-504790104-1169604174=:7739
Content-Type: TEXT/PLAIN; charset=US-ASCII


On Tue, 23 Jan 2007, Oleg Verych wrote:

> On 2007-01-23, Robert P. J. Day wrote:
> []
> >   what it does is scan the entire tree for lines of the form
> >
> > ...if... CONFIG_whatever...
> >
> > collects all of those CONFIG variables and, one at a time, checks to
> > see if that variable even exists in any Kconfig file in the tree so
> > that it could possibly ever be set.  (i'm not guaranteeing that the
> > script is perfect, but it does generate some interesting results.)
> >
> >   the first few lines of output:
> >
> > 53C700_BE_BUS
> > 64_BIT
> > 68328_SERIAL_UART2
> > ...
> >
> []
> >   the script turns up 284 examples of this.
>
> Next, this script must to learn how to search whom to send this info.
> And if there's nobody, just to make list of known orphans ;).

  i'm pretty sure that's not going to happen this evening, but i
tweaked the script just a bit so you can run it (from the top-level
directory) against any subdirectory to see what CONFIG symbols appear
to be (for lack of a better word) "orphaned."

  let's test it against, say, fs/xfs:

$ ../config_vars.sh fs/xfs
FS_POSIX_CAP
FS_POSIX_MAC
XFS_DEBUG
XFS_DMAPI
XFS_TRACE

$ grep -r FS_POSIX_CAP .
fs/xfs/xfs_cap.h:#ifdef CONFIG_FS_POSIX_CAP

$ grep -r FS_POSIX_MAC .
./fs/xfs/xfs_mac.h:#ifdef CONFIG_FS_POSIX_MAC

$ grep -r XFS_DEBUG .
./fs/xfs/xfs.h:#ifdef CONFIG_XFS_DEBUG
./fs/xfs/Makefile-linux-2.6:ifeq ($(CONFIG_XFS_DEBUG),y)

and so on.  of course, there may be good reasons for some of these
variables to be there with no corresponding Kconfig entry -- i'm just
printing them out.

rday

p.s. new script is attached.
--0-504790104-1169604174=:7739
Content-Type: APPLICATION/x-sh; name=config_vars.sh
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0701232102540.7739@CPE00045a9c397f-CM001225dbafb6>
Content-Description: 
Content-Disposition: attachment; filename=config_vars.sh

IyEvYmluL3NoCgpESVI9JHsxLS59CgpDVj0kKGdyZXAgLXJoICJeIy4qaWYu
KiBDT05GSUdfW0EtWmEtejAtOV0iICR7RElSfSB8IGdyZXAgLXYgZW5kaWYp
CkNWQVJTPSQoZWNobyAiJHtDVn0iIHwgc2VkICJzLy4qXChDT05GSUdfW14J
ID1cKVwqXC9dKlwpLiovXDEvIiB8IHNvcnQgLXUgfCBncmVwICJeQ09ORklH
XyIpCgprY2ZpbGVzPSQoZmluZCAuIC1uYW1lICJLY29uZmlnKiIpCgpmb3Ig
Y3YgaW4gJHtDVkFSU30gOyBkbwoJIyBlY2hvICJjdiA9ICR7Y3Z9IgoJc3Ry
PSQoZWNobyAke2N2fSB8IHNlZCAicy9eQ09ORklHXy8vIikKCSMgZWNobyAi
c3RyID0gJHtzdHJ9IgoJZ3JlcCAtd3EgJHtzdHJ9ICR7a2NmaWxlc30gfHwg
ewoJCWVjaG8gJHtzdHJ9CgkJIyBncmVwIC1yICR7c3RyfSAke0RJUn0JCSMg
dW5jb21tZW50IGlmIHlvdSB3YW50Cgl9CmRvbmUK

--0-504790104-1169604174=:7739--
