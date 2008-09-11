Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYIKUNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYIKUNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYIKUNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:13:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbYIKUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:13:18 -0400
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Thu, 11 Sep 2008 22:11:05 +0200
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
From: Harun Scheutzow <harun04@scheutzow.de>
Subject: Re: vfat file system extreme fragmentation on multiprocessor
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080911191049.GB31271@csclub.uwaterloo.ca>
References: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de>
 <20080911191049.GB31271@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <0ML31I-1KdsXT0vcs-0006v2@mrelayeu.kundenserver.de>
X-Provags-ID: V01U2FsdGVkX18k3mELMno0YEKxATgAp1KlqNIRmyGmD2zxsIs
 204wtLG9K02FwNHHijSYdysrt+pc5FEclFVZf33ZLYMZvps+nk
 bj+2csWWVHxRWlkPPWVCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 21:10 11.09.2008, Lennart Sorensen wrote:

Why do you start a flame war against fat fs without the proper knowledge? This is of no help.

ext2 is no magic bullet. As any other file system which does not rearrange clusters on the fly (this is defragmentation), it can only prevent fragmentation by wasting space, that means it seems not to fragment at 25 % full, but does at 90 %, just depending on size of files created. Initially wasting space and on-the-fly defragmentation can be done on FAT as well, if the driver likes to do.

All this NOT the problem here. It is NOT what I'm asking for.


>Now what would happen if you used ftruncate to extend the file you open
>to a large size, and then started writing it, and then set the size
>correctly at the end?

Because ftruncate has to allocate the clusters the same way fwrite does, it would probably give the same results.


Anyway, I want to keep things simple. I do not know the final file size in advance, may be 550 MByte, often 200, but can be 5. It is perfectly ok to get 4 fragments per 200 MByte. All I suggest is that a file system which is told to write 50 MByte a piece, does so.

I do not want to synchronize the two applications, preventing them from writing at the same time. But currently this seems to be the only option.

Harun Scheutzow

