Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYDAFbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYDAFbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 01:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYDAFbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 01:31:06 -0400
Received: from smtp.nokia.com ([192.100.105.134]:60056 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYDAFbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 01:31:05 -0400
Message-ID: <47F1C78D.2050300@yandex.ru>
Date: Tue, 01 Apr 2008 08:26:37 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org>
In-Reply-To: <20080331132047.GA31660@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 05:30:25.0533 (UTC) FILETIME=[7CFE42D0:01C893B9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've renamed the thread because I do not like this flamish discussion
to me mixed with the technical one.

Jörn Engel wrote:
> Shiny numbers!  Performance has improved significantly in the last six
> month.  Still worth a closer look.
We'll re-run them. Does logfs support write-back? Does it support compression?
Is this patch the right one we should look at:

>> 3. logfs does not seem to have bad-block handling.
> 
> Bad blocks at mkfs time are handled, blocks turning bad later on aren't
> yet.

This basically means it is unfinished. Handling dynamic bad blocks is a *must*
if you are going to work on NAND, especially on MLC NAND which are not as
reliable as SLC.

I think you should bluntly say about this when you submit patches to prevent
people from starting using it in production.

UBI handles I/O errors and gracefully recovers the data. And it will not be
easy to do this in LogFS at all. If you have write error in the middle of an
eraseblock, you have to recover data which means correcting all the indexing
data structures which refer the data you recover. Correcting them may require
garbage collection, because you have to update them out of place. And what
do you do if you are already in the middle of doing garbage-collection?

In other words, I believe it will take a lot of time and efforts to implement
this. And any speculation about the number of lines of code makes no sense
before you finish your work.

>> 4. logfs does not seem to have wear-leveling.
> It does.
Could you please point the core functions which implement this and shortly
describe the algorithm?

I grep'ed for "wear" and "leveling" and found only one match. Where should
I look at?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
