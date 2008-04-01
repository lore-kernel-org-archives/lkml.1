Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYDAGBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYDAGBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYDAGAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:00:52 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49219 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYDAGAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:00:51 -0400
Message-ID: <47F1CE9D.4080709@nokia.com>
Date: Tue, 01 Apr 2008 08:56:45 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F1C78D.2050300@yandex.ru>
In-Reply-To: <47F1C78D.2050300@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 06:00:38.0666 (UTC) FILETIME=[B5B466A0:01C893BD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Code size difference is huge.  Ubi weighs some 11kloc, ubifs some 30,
> logfs some 8.
Please, lets refrain form unfair comparisons like this before logfs is
finished. Also, when you compare, please, take into account that UBI/UBIFS
has many times more commentaries in the code.

> Ubi scales linearly, as it does a large scan at init time.  It is still
> reasonably fast, as it reads just a few bytes worth of header per block.
> Logfs mounts in O(1) but will currently become mindbogglingly slow when
> the filesystem nears 100% full and write are purely random.  Not that
> any other flash filesystem would perform well under these conditions -
> it is the known worst case scenario.
I asked you some time ago to describe how you maintain per-eraseblock
space accounting [1]. E.g., how you select an eraseblock for garbage
collection, how do you store the accounting information.

You said you find eraseblocks by scanning. This means logfs is not
really scalable because you may spend ages before you find anything
appropriate. When the FS is almost full, yo need to scan nearly
whole flash to find an eraseblock? So if I mount a nearly full 
FS, and start writing, I'll get my request handled when nearly whole
media is scanned?

UBIFS stores per-eraseblock information on the media in a B-tree, and
it also has lists of empty/dirty eraseblocks, which allow to very quickly
find the best eraseblock to garbage-collect or to write to.

[1] http://lkml.org/lkml/2007/8/8/333

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
