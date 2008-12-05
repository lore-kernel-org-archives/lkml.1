Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYLED10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYLED10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYLED07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:26:59 -0500
Received: from sandeen.net ([209.173.210.139]:13373 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502AbYLED07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:26:59 -0500
Message-ID: <49389F81.1090306@sandeen.net>
Date: Thu, 04 Dec 2008 21:26:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Milan Broz <mbroz@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, xfs@oss.sgi.com
Subject: Re: Device loses barrier support
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>	<20081204100050.GN6703@one.firstfloor.org>	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>	<20081204142015.GQ6703@one.firstfloor.org>	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>	<20081204145810.GR6703@one.firstfloor.org>	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>	<20081204174838.GS6703@one.firstfloor.org> <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka wrote:

> Another thing:
> 
> I'm wondering, where in fsync() does Linux wait for hardware disk cache to 
> be flushed? Isn't there a bug that fsync() will return before the cache is 
> flushed? I couldn't really find it. The last thing do_fsync calls is 
> filemap_fdatawait and it doesn't do cache flush (blkdev_issue_flush).

ext4, reiserfs, and xfs all call blkdev_issue_flush() in their ->fsync
file operations (or down that path).

-Eric
