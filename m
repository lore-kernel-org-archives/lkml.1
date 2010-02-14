Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab0BNNut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 08:50:49 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:62783 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab0BNNur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 08:50:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=PQ+Y8EToX/jXf6OnimVwGgD4JczSFqFOoE5b3Tz75eM+y1rF7sowg7hqxBMBbqmaZL
         dDxcgdyAg+ZgGolOuw03uPfIhsDvY10Quu0bOOc3uvLN/xFKVkGQ7YAs7B7B5aFxfjTL
         tx5UqZrtD4nxK5k/NHbTIGy2sJBypV6ZPBd9k=
MIME-Version: 1.0
Date: Sun, 14 Feb 2010 22:50:45 +0900
Message-ID: <b3f268591002140550x746b96aeo3c7a017ac4ecf993@mail.gmail.com>
Subject: Extents in spare files on ext4 not being merged
From: Jari Sundell <sundell.software@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://libtorrent.rakshasa.no/ticket/460#comment:49

Some users of rtorrent reported very high number of extents for files
despite the use of posix_fallocate/fallocate on ext4. (3000+ for 250MB
file, ) A test program showed that the file was contiguous on disk
despite the high number of extents reported by filefrag. (Not sure
what kernel versions they used)

---
Opening file '/mnt/d1/part1.wmv'.
Block size: 4096
File size:  196571350
Block/page count: 47992
   1: log        0   bb78 phys     8800   bb77

Size of the file is 187.5 MB and filefrag reports 1505 extents.
---

So for some reason the extents aren't getting merged when mmaped
regions get sync'ed in a random order to disk.

Jari Sundell
