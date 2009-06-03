Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZFCGeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZFCGeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZFCGd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:33:58 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47082 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbZFCGd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:33:56 -0400
MIME-Version: 1.0
Date: Wed, 3 Jun 2009 07:33:57 +0100
X-Google-Sender-Auth: dd5f4d514b4dadb2
Message-ID: <b2cdc9f30906022333s7f206f6w73773714dd57cd1a@mail.gmail.com>
Subject: Very high loadavg when syncing iPod with rsync over USB
From: Alex Bennee <kernel-hacker@bennee.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this expected behaviour?

While the USB bus is not the fastest thing in the world and I would
expect the rsync process to be blocking on I/O to the iPod's disk I'm
seeing a very high loadavg (12 or so) that seems to indicate lots of
other things are blocking. Other noticeable magnifications include jumpy
sound playback from my music player.

My ipod sync is basically just a:

rsync -r --progress /home/alex/music/ /media/disk/music/

and has been running for the best part of 7 hours so far syncing my
collection up.

Is this just a consequence of the read side of rsync on my local disk
sucking up all the I/O bandwidth?

vmstat doesn't look overly magical:

danny ~ # vmstat -n 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1 11  24124  19516  31852 1440072    0    0   303   319   77   20  7  1 63 28
 1 11  24124  18956  31896 1439924    0    0   100   212  957 3197  7  3  0 90
 1 11  24164  18892  31912 1440208    0   40   356   380  924 3088  6  1  0 92
 0 11  24164  18824  31916 1440288    0    0   238   348  842 2739  3  2  0 95
 2 10  24164  18680  31984 1440212    0    0   136   272  972 2852 32  2  0 65
 3 10  24164  18388  31984 1439736    0    0    12   956 1282 2878 96  2  0  2
 0 11  24164  19680  31976 1439608    0    0    70   592 1097 2957 75  4  0 21
 1 11  24164  19352  31964 1439536    0    0   230   584  791 2513  2  2  0 96
 0 11  24164  19012  31972 1439820    0    0   288   320  823 2496  6  1  0 93
 0 11  24164  18856  31984 1440072    0    0   138   412  934 2964  5  3  0 92
 0 11  24164  19392  32004 1439904    0    0   140   904  842 2562  5  1  0 94
 0 11  24164  19492  32008 1438908    0    0   524   260  983 2988  8  3  0 89
 0 11  24164  19464  32012 1438664    0    0   198   596  900 2638  5  2  0 93
 0 11  24164  19332  32028 1438724    0    0   182   208  945 2960  9  3  0 88


Current kernel is 2.6.30-rc7

-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
