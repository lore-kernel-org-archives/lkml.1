Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbZHVQ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbZHVQ1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 12:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932878AbZHVQ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 12:27:14 -0400
Received: from mail2.shareable.org ([80.68.89.115]:40065 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822AbZHVQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 12:27:13 -0400
Date: Sat, 22 Aug 2009 17:27:11 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/17] Make O_SYNC handling use standard syncing path (Version 2)
Message-ID: <20090822162711.GA7542@shareable.org>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> The patch set unifines O_SYNC handling with standard fsync() path.  After this,
> we have just one place forcing a single file to disk so filesystems like ext3 /
> ext4 don't have to force a transaction commit in ext?_file_write for O_SYNC
> files / IS_SYNC inodes.  The code is also cleaner this way (actually about 150
> lines shorter), we don't sync the inode several times as it happened previously
> etc.

Afaik, O_SYNC requires just the written data to be committed to disk,
but fsync() requires all dirty data for the file (including written by
other processes / descriptors) to be committed to disk.

So doing the equivalent of fsync() after write might be the wrong
thing to do.

-- Jamie
