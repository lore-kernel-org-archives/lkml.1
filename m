Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbXGWKwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbXGWKwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXGWKwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:52:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:29319 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXGWKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RSgmw72nkOfgcVn8wBxPzJWUjzeqobo08tpv2RblVZuzk4Hw0vGsacIiEn1SM87xjCgImbXlXF2/b2kKn9a002tIK3Do4kv89KT913P8FMKgdATNQGOzOkcOMbP6l/IvNL3Z/K/9qtFeg0J9I0bmwX1Bu6KX64LiT9wnLhMgmC4=
Message-ID: <5d75f4610707230352j69b2ba53g1564e420fc64ea49@mail.gmail.com>
Date: Mon, 23 Jul 2007 17:52:31 +0700
From: "BuraphaLinux Server" <buraphalinuxserver@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: SCSI vs SATA
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

    I have had a hard time determining if /dev/sda is SCSI or SATA
from my boot scripts.  It matters for smartd which needs an added
parameter -d sat in the configuration file for SATA drives.  Finally I
came up with this, but I wonder if there is a better way?  It appears
that
vendor is "ATA     " (5 trailing spaces) for SATA.  If the kernel is
ever fixed to show proper vendor information (Maxtor, Seagate,
whatever) then how can I know if /dev/sda is SCSI or SATA from a bash
script?  When flaming me, please also include the proper solution.
Thanks.

#!  /bin/bash
drive="sda"
vendor=$(</sys/block/${drive}/device/vendor)
if [[ "${vendor}" = "ATA     " ]]
then
  printf "SATA\n"
else
  printf "SCSI\n"
fi
exit 0
