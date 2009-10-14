Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbZJNMxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbZJNMxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbZJNMxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:53:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47978 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbZJNMxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:53:00 -0400
Message-ID: <4AD5C97B.4080509@garzik.org>
Date: Wed, 14 Oct 2009 08:52:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Alexandros C. Couloumbis" <alex@ozo.com>,
       linux-ide@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] pata_sc1200: Fix crash on boot
References: <20091006150737.9610.81541.stgit@localhost.localdomain> <20091013185637.870369c8.akpm@linux-foundation.org> <20091014130046.0aa13166@lxorguk.ukuu.org.uk> <200910141412.29467.bzolnier@gmail.com>
In-Reply-To: <200910141412.29467.bzolnier@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070602080407050403050203"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070602080407050403050203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/2009 08:12 AM, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 14 October 2009 14:00:46 Alan Cox wrote:
>>> This patch applies to 2.6.31 and 2.6.30 (at least).  How far back
>>> should it be ported?
>>
>> No idea. I was just getting it fixed for the maintainer while waiting for
>> something else to build.
>
> BTW do you happen to know who is the current maintainer of this driver
> (ditto for other PATA drivers)?
>
> MAINTAINERS lists only:
>
> 	SERIAL ATA (SATA) SUBSYSTEM
> 	P:      Jeff Garzik
> 	M:      jgarzik@pobox.com
> 	L:      linux-ide@vger.kernel.org
> 	T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 	S:      Supported
> 	F:      drivers/ata/
> 	F:      include/linux/ata.h
> 	F:      include/linux/libata.h
>
> but this driver surely ain't SATA.

FWIW, I've been treating Alan as "PATA sub-maintainer", and tend to wait 
for an Alan review of a PATA driver patch before applying it [unless 
it's blindingly obvious or Bart chimes etc.].

But yes, overall, libata is certainly not SATA-only anymore, and 
MAINTAINERS should reflect that.

Maybe a patch like the attached?  (DaveM CC'd, since I modified the 
old-IDE entry as well)

	Jeff



--------------070602080407050403050203
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch"

diff --git a/MAINTAINERS b/MAINTAINERS
index 69e31aa..1a756bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2581,7 +2581,7 @@ W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
 S:	Supported
 F:	drivers/scsi/ips.*
 
-IDE SUBSYSTEM
+Old IDE SUBSYSTEM
 M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-ide@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
@@ -4644,7 +4644,7 @@ S:	Maintained
 F:	drivers/misc/phantom.c
 F:	include/linux/phantom.h
 
-SERIAL ATA (SATA) SUBSYSTEM
+ATA SUBSYSTEM
 M:	Jeff Garzik <jgarzik@pobox.com>
 L:	linux-ide@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

--------------070602080407050403050203--
