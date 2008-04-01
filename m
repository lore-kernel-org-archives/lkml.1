Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYDAJnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYDAJnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbYDAJnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:43:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49262 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbYDAJnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:43:31 -0400
Message-ID: <47F202CD.4000804@yandex.ru>
Date: Tue, 01 Apr 2008 12:39:25 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F1C78D.2050300@yandex.ru> <47F1CE9D.4080709@nokia.com> <20080401092548.GC7465@logfs.org>
In-Reply-To: <20080401092548.GC7465@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 09:43:16.0047 (UTC) FILETIME=[CF52FDF0:01C893DC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Correct.  I have a patch that caches this information in RAM, so the
> worst-case scenario is to do the full scan once - if the filesystem is
> near 100% full and performance is down the drain anyway.  The goal is
> obviously to store that information on the medium.

Anyway, if you do not store this information on the flash, you are going
to scan to acquire it. You may have caches, but they do not have to have
information (may be empty), then you scan. This will lead to scalability
problems at some point anyway.

>> UBIFS stores per-eraseblock information on the media in a B-tree, and
>> it also has lists of empty/dirty eraseblocks, which allow to very quickly
>> find the best eraseblock to garbage-collect or to write to.
> 
> So how do you solve the catch-22?

I'm not sure what you mean. In UBIFS we have lprops area, where we store
per-LEB accounting. UBI lets it possible to have it on a fixed position.
The accounting is a separate B-tree. Lprops area has its own independent
garbage collector. You should probably refer the white paper for more
information.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
