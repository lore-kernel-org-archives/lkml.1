Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYFADTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYFADTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 23:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYFADTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 23:19:43 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:63813 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbYFADTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 23:19:42 -0400
Message-ID: <4842155D.2000002@lougher.demon.co.uk>
Date: Sun, 01 Jun 2008 04:19:57 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: arnd@arndb.de
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
References: <200805311737.58991.arnd@arndb.de>
In-Reply-To: <200805311737.58991.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arnd@arndb.de wrote:
> Many existing systems currently use unionfs or aufs for this
> purpose, by overlaying a tmpfs over a read-only file
> system like cramfs, squashfs or iso9660. IMHO, it would
> be a much nicer solution to not require unionfs for a simple
> case like this, but rather have support for it in the file
> system. If people find this useful, we can do the same in
> other read-only file system.

I think it's a good idea, and I have been thinking about adding 
something similar to Squashfs for a quite a while (when I get time).

> Comments?

Patch 2 ([RFC 2/7] cramfs: create unique inode numbers) changes the 
inode number to be based on the dentry location rather than the file 
location.  This is a user-visible change, not only do empty directories, 
char, block, pipe, and sockets get real inode numbers rather than 1 (a 
good thing IMHO), but files that were hard-linked (in the original 
source directory) now get different inode numbers.  Obviously cramfs has 
never properly supported hard links, but the duplicate file check in 
cramfs did ensure hard linked files got the same inode number.

This change in behaviour may break some existing users of cramfs 
filesystems.  It may be worth sending the RFC and patches etc. to the 
new linux-embedded mailing list to get some feedback from the embedded 
folks who use cramfs.

Phillip


