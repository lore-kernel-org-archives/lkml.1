Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbXIEM4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbXIEM4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbXIEM4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:56:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:24587 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbXIEM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=P3Sckjxf1a7tRTKR15sB/Yc4bLSZ+HyDz37SaryiYfdlIxRkb2vwq+OvRtffruZkp4g58GuBZqUBgcGhoWXIzWr10Gtu2cf2vnJ9mUHP3oK3f3HBxUCzl3TrmT+/b1HvjsWydG7mOxkITuBGZqwaxSJssCszU/Qd7TUev0HqpcU=
Message-ID: <46DEA755.4030604@googlemail.com>
Date: Wed, 05 Sep 2007 14:55:49 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, CK Mailinglist <ck@vds.kolivas.org>
Subject: [ANNOUNCE] DeskOpt 005 (completely unfair scheduling ;))
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Completely fair scheduling is really good thing, but if you want the best
performance for certain application you need to tune up some things.

DeskOpt is designed to help people tune up their systems for certain tasks.

Here are the results from the Nexuiz benchmark

|------------------------------------------------------------------------|
|                          |    CFS + CFQ      |   CFS + CFQ + DeskOpt * |
|------------------------------------------------------------------------|
| timedemo demos/demo2     | 41,395896833 fps  |   41,460051233 fps      |
|--------------------------|-------------------|-------------------------|
| timedemo demos/demo2     | 18,343223633 fps  |   37,814504933 fps      |
| + massive_intr 4 1000    |                   |                         |
|--------------------------|-------------------|-------------------------|
| timedemo demos/demo2     | 9,334974533 fps   |   37,376611267 fps      |
| + massive_intr 8 1000    |                   |                         |
|------------------------------------------------------------------------|

* default class for games

Software requirements:
- Python 2.x (http://python.org/)
- elementtree (http://effbot.org/downloads/#elementtree)

DeskOpt installation:
cp deskopt /usr/local/bin/
mkdir /etc/deskopt/
cp deskopt.conf /etc/deskopt/
cp deskopt.rc /etc/init.d/

The configuration file must be a valid XML file.

CFQ tuning:
back_seek_max
back_seek_penalty
fifo_batch_expire
fifo_batch_async
fifo_batch_sync
quantum
slice_sync
slice_idle
slice_async
slice_async_rq

http://lwn.net/Articles/101029/
http://lwn.net/Articles/114273/

Anticipatory tuning:
antic_expire
read_batch_expire
read_expire
write_batch_expire
write_expire

Documentation/block/as-iosched.txt

Deadline tuning:
fifo_batch
front_merges
read_expire
write_expire
writes_starved

Documentation/block/deadline-iosched.txt
http://kerneltrap.org/node/431


Usage: deskopt [options]

Options:
  -h, --help            show this help message and exit
  -c CONFIG_FILE, --config-file=CONFIG_FILE
                        Configuration file
  -d, --debug           Debug
  -H HDD, --hard-drives=HDD
                        List of hard drives
  -l LOOP_TIME, --loop-time=LOOP_TIME
                        Loop time
  -q, --quit            Quit
  -v, --version         Show version number

Example:
# deskopt -c /path/to/my/config/file.conf --hard-drives="sda hdb" -l 60
or
# deskopt -c /path/to/my/config/file.conf

The latest version of DeskOpt can be downloaded from 
http://www.stardust.webpages.pl/files/tools/deskopt/

Changelog:
- support for Anticipatory and Deadline scheduler (requested by Chris Snook)
- support for a different hard drives (previous version was limited to hdd
  with /usr partition)
- something like a documentation (requested by Satyam Sharma)
- the code looks a bit better now

diff -uprN deskopt-004/deskopt deskopt-005/deskopt | diffstat
 deskopt |  870 +++++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 562 insertions(+), 308 deletions(-)

TODO:
- support for device queue length tuning (suggested by Andi Kleen)
- kill signal handling, bug fixes etc.

Comments and suggestions are welcome.

It still has many flaws :)

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
