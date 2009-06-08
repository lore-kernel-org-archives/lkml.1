Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZFHONT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZFHONT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZFHONH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:13:07 -0400
Received: from mail-px0-f200.google.com ([209.85.216.200]:65114 "EHLO
	mail-px0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZFHONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:13:06 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2009 10:13:06 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=Os/51VCBp2NHjSdkfide9LJM+71Co0++pNKp/1utJ8wbOTvOk0B3tMZoBI5QbCPJYH
         rnwcBwI58ZfXPeSTCvhqxO0fQvA7JLP4AjXuDAUY8d4nMKnFyBFdnTZPjq9c14HLSdau
         ItVnt9OOvxxuNndDRYZ/0ETFCRkWzYWg7xxAM=
MIME-Version: 1.0
From: Wenqiang Song <wsong.cn@gmail.com>
Date: Mon, 8 Jun 2009 22:05:00 +0800
Message-ID: <6f9b6d3e0906080705g3692f1b7l9c75322633ea6d29@mail.gmail.com>
Subject: Squashfs 4.0 performance benchmark
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n58EDw54007344

Hi folks,
I just did a performance test on Squashfs 4.0, similar to this one:http://www.celinuxforum.org/CelfPubWiki/SquashFsComparisons
The result is quit good. But I don't understand why performance isbetter on a loop back file than raw partition.
My test machine:AMD Sempron(tm) Processor LE-1200, 2G memory
Ext4 uncompressed data: 2887704KSquashfs 4.0 Image: 1256892K, generate by "mksquashfs . test.squash"
2.1.1 Directory Lookup performanceTime taken to perform "ls -lR --color=alawys | cat > /dev/null" onfilesystem mounted
First time, Ext4real    0m13.896suser    0m3.556ssys     0m4.436s
Second time, Ext4real    0m6.700suser    0m2.676ssys     0m2.816s

First time, Squashfs on raw partitionreal    0m9.850suser    0m2.268ssys     0m6.712s
Second time, Squashfs on raw partitionreal    0m4.487suser    0m2.096ssys     0m2.392s

First time, Squashfs loop back file on an Ext4 partition.real    0m8.356suser    0m2.104ssys     0m6.112s
Second time, Squashfs loop back file on an Ext4 partition.real    0m5.112suser    0m2.116ssys     0m2.992s
---------------------------------------------------------------------------------------------2.1.2 Sequential I/O performance
Time taken to perform "tar cf - | cat > /dev/null" on filesystem mounted
Ext4real    5m28.694suser    0m3.816ssys     0m29.966s

Squashfs on raw partitionreal    1m23.226suser    0m2.416ssys     1m2.680s

Squashfs loop back file on an Ext4 partition
real    0m53.867suser    0m1.820ssys     0m42.611s

--------------------------------------------------------------------------------------------2.1.3 Random I/O performanceRandom access pattern generated by find . -type f -printf "%s %p\n" |sort -g | awk '{ print $2 }' > /tmp/sort
First time, Ext4real    33m21.603suser    0m5.724ssys     0m33.734s
Squashfs on raw partitionreal    7m35.962suser    0m4.192ssys     5m40.973s
Squashfs loop back file on an Ext4 partitionreal    5m33.566suser    0m3.316ssys     4m47.942s
----------------------------------------------same test with 256M memorySquashfs on raw partitionreal    10m25.518suser    0m4.432ssys     6m41.133s
Squashfs loop back file on an Ext4 partitionreal    11m0.271suser    0m5.156ssys     6m59.942s

Wenqiang Song
--有志者，事竟成，破釜沉舟，百二秦关终属楚苦心人，天不负，卧薪尝胆，三千越甲可吞吴���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
