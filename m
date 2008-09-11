Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYILAYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYILAYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 20:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYILAYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 20:24:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYILAYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 20:24:35 -0400
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Fri, 12 Sep 2008 01:03:03 +0200
To: linux-kernel@vger.kernel.org
From: Harun Scheutzow <harun04@scheutzow.de>
Subject: Re: vfat file system extreme fragmentation on multiprocessor
Cc: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
In-Reply-To: <20080911212001.GD31271@csclub.uwaterloo.ca>
References: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de>
 <20080911191049.GB31271@csclub.uwaterloo.ca>
 <0ML31I-1KdsXT0vcs-0006v2@mrelayeu.kundenserver.de>
 <20080911212001.GD31271@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <0ML25U-1KdwSf0P4s-0006TS@mrelayeu.kundenserver.de>
X-Provags-ID: V01U2FsdGVkX19pdQG3ZZytkvZAdXJIq5y3NMSI71F1gTZaUr0
 0s5KvAq77aQmtjW6a6oJyln2pPOlcsLHlCs7DPL5e5OV+RPQny
 O37oXOAi5Q02tt7XcP+Yw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why should C library fwrite() split anything? There is no good reason (unless in x86 64 KByte segmented model trying to emulate a flat model - old DOS). The 50 MByte go to write() in a single piece here.

There are only very little "single operation"s in kernel nowadays. In most cases this is a good thing.

Looks like fat/fatent.c fat_alloc_clusters() is limited to allocate only 4 clusters under a single lock.

Found another assumption I do not like: cluster size >= 512. There are old FAT systems on SRAM cards having 128 byte/sector and cluster. But I don't want to have long filenames on them. Hope the 512 does not sit elsewhere, too.

fat/inode.c __fat_get_block() /* TODO: multiple cluster allocation would be desirable */
YES, OF COURSE. Only a single cluster is allocated at a time, no lock here, I can be happy I got still 8 clusters per fragment, might have been only 1.

Harun

