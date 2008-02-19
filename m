Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYBSPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYBSPIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYBSPIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:08:05 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:64839 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYBSPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:08:03 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Date: Tue, 19 Feb 2008 10:06:50 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <47B980AC.2080806@wpkg.org> <20080218141640.GC12568@mit.edu> <47BAED94.3040103@wpkg.org>
In-Reply-To: <47BAED94.3040103@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191006.50693.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Tomasz Chmielewski wrote:
> Theodore Tso schrieb:
>
> (...)
>
> > The following ld_preload can help in some cases.  Mutt has this hack
> > encoded in for maildir directories, which helps.
>
> It doesn't work very reliable for me.
>
> For some reason, it hangs for me sometimes (doesn't remove any files, rm
> -rf just stalls), or segfaults.

You can go the low-tech route (assuming your file names don't have spaces in 
them)

find . -printf "%i %p\n" | sort -n | awk '{print $2}' | xargs rm

>
>
> As most of the ideas here in this thread assume (re)creating a new
> filesystem from scratch - would perhaps playing with
> /proc/sys/vm/dirty_ratio and /proc/sys/vm/dirty_background_ratio help a
> bit?

Probably not.  You're seeking between all the inodes on the box, and probably 
not bound by the memory used.

-chris
