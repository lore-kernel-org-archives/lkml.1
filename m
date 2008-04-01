Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYDAJU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYDAJU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYDAJUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:20:14 -0400
Received: from lazybastard.de ([212.112.238.170]:54159 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbYDAJUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:20:13 -0400
Date: Tue, 1 Apr 2008 11:19:46 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080401091945.GB7465@logfs.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F1C78D.2050300@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F1C78D.2050300@yandex.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 April 2008 08:26:37 +0300, Artem Bityutskiy wrote:
> Jörn Engel wrote:
> >Shiny numbers!  Performance has improved significantly in the last six
> >month.  Still worth a closer look.
> We'll re-run them. Does logfs support write-back? Does it support 
> compression?

Write-back of metadata: yes.  Write-back of data: currently not.
Compression: yes.

> Is this patch the right one we should look at:
> http://logfs.org/logfs/patches

Yes.

> >>3. logfs does not seem to have bad-block handling.
> >
> >Bad blocks at mkfs time are handled, blocks turning bad later on aren't
> >yet.
> 
> This basically means it is unfinished. Handling dynamic bad blocks is a 
> *must*
> if you are going to work on NAND, especially on MLC NAND which are not as
> reliable as SLC.
> 
> I think you should bluntly say about this when you submit patches to prevent
> people from starting using it in production.
> 
> UBI handles I/O errors and gracefully recovers the data. And it will not be
> easy to do this in LogFS at all. If you have write error in the middle of an
> eraseblock, you have to recover data which means correcting all the indexing
> data structures which refer the data you recover. Correcting them may 
> require
> garbage collection, because you have to update them out of place. And what
> do you do if you are already in the middle of doing garbage-collection?
> 
> In other words, I believe it will take a lot of time and efforts to 
> implement
> this. And any speculation about the number of lines of code makes no sense
> before you finish your work.

You are right, bad-block handling is easier to implement in ubi than in
a filesystem.  That is one of the real benefits from using ubi.  And if
my other arguments about ubi would have been handled instead of answered
with flames, I would likely be using it as well.

> >>4. logfs does not seem to have wear-leveling.
> >It does.
> Could you please point the core functions which implement this and shortly
> describe the algorithm?
> 
> I grep'ed for "wear" and "leveling" and found only one match. Where should
> I look at?

fs/logfs/gc.c
Grep for s_ec_list.  It is currently quite aggressive and keeps the
spread between maximum erasecount and minimum erasecount at about 40.
Should become an mkfs option one of these days.

There is no dedicated subsystem for wear leveling.  There simply isn't
that much to do.

Jörn

-- 
Premature optimization is the root of all evil.
-- Donald Knuth
