Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYI3OuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYI3OuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYI3OuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:50:12 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:4592 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYI3OuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:50:11 -0400
Date: Tue, 30 Sep 2008 09:50:05 -0500 (CDT)
Message-Id: <200809301450.m8UEo5wT027331@sullivan.realtime.net>
Subject: How can i read really 512 byte?
From: Milton Miller <miltonm@bga.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3c8f01c922f7$a032a570$0400a8c0@dcccs>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 at 08:29:15 -0400 (EDT), Janos Haar wrote:
> Now i am working on recover some data from one defective drive.  I
> am using dd_rescue, and dd, but both ready only 4K, i think, because
> the kernel's block size is 4K.
> 
> I have tried to google for the solution, but only found this trick:
> 
> losetup /dev/loop0 /dev/hdc
> blockdev --setbsz 512 /dev/hdc
> 
> and after this set, trying to read the hdc...
> 
> It looks like working on the first look, but not really. :-( The
> 512 size bad sectors still have 4K sizes, but the reading attempt
> takes more (8x ?) longer.
> 
> Somebody can help me to set the reading block size to 512 byte?

You need to add O_DIRECT to the open call in the flags parameter
(the second argument).   (My brother tested this a year or so ago,
and it worked for him).

milton
