Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZKPDix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZKPDix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 22:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZKPDiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 22:38:52 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:60504 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZKPDiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 22:38:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=UBlgwWbmkylfIKM5lJefmz6tPrdBaG6ltj0VwEOr2thJ/hOPK2yUrl68/EC95tiIkF
         7LU7j/hrAmDbGprUdjFYgot3vRRW2jOy82bbFK4UQKVvsi0/SwpgaQ6pDA+B05yvaVYX
         Kt4aDSnT3ZbwQuyk/nyuMZLftmB4tvyeT3We0=
MIME-Version: 1.0
Date: Mon, 16 Nov 2009 11:38:57 +0800
Message-ID: <2df346410911151938r1eb5c5e4q9930ac179d61ef01@mail.gmail.com>
Subject: [BUG]2.6.27.y some contents lost after writing to mmaped file
From: JiSheng Zhang <jszhang3@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I triggered a failure in an fs test with fsx-linux from ltp. It seems that
fsx-linux failed at mmap->write sequence.

Tested kernel is 2.6.27.12 and 2.6.27.39
Tested file system: ext3, tmpfs.
IMHO, it impacts all file systems.

Some fsx-linux log is:

READ BAD DATA: offset = 0x2771b, size = 0xa28e
OFFSET  GOOD    BAD     RANGE
0x287e0 0x35c9  0x15a9     0x80
operation# (mod 256) for the bad datamay be 21
...
7828: 1257514978.306753 READ     0x23dba thru 0x25699 (0x18e0 bytes)
7829: 1257514978.306899 MAPWRITE 0x27eeb thru 0x2a516 (0x262c bytes)
 ******WWWW
7830: 1257514978.307504 READ     0x2771b thru 0x319a8 (0xa28e bytes)
 ***RRRR***
Correct content saved for comparison
...
