Return-Path: <linux-kernel-owner+w=401wt.eu-S1751992AbYCaNka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbYCaNka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYCaNkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:40:23 -0400
Received: from lazybastard.de ([212.112.238.170]:45931 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYCaNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:40:23 -0400
Date: Mon, 31 Mar 2008 15:40:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, joern@lazybastard.org
Subject: Re: [RFC PATCH] UBIFS - new flash file system
Message-ID: <20080331134004.GA465@logfs.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 March 2008 14:29:59 +0200, Jan Engelhardt wrote:
> On Thursday 2008-03-27 15:55, Artem Bityutskiy wrote:
> >
> >here is a new flash file system developed by Nokia engineers with
> >help of the University of Szeged. The new file-system is called
> >UBIFS, which stands for UBI file system. UBI is the wear-leveling/
> >bad-block handling/volume management layer which is already in
> >mainline (see drivers/mtd/ubi).
> >[...]
> 
> And how does it compare to logfs?

Both share similar design goals.  Biggest difference is that ubifs works
on top of ubi and depends on ubi support, while logfs works on plain mtd
(or block devices) and does everything itself.

Code size difference is huge.  Ubi weighs some 11kloc, ubifs some 30,
logfs some 8.

Ubi scales linearly, as it does a large scan at init time.  It is still
reasonably fast, as it reads just a few bytes worth of header per block.
Logfs mounts in O(1) but will currently become mindbogglingly slow when
the filesystem nears 100% full and write are purely random.  Not that
any other flash filesystem would perform well under these conditions -
it is the known worst case scenario.

Jörn

-- 
Victory in war is not repetitious.
-- Sun Tzu
