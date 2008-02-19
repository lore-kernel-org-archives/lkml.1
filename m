Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbYBSKXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbYBSKXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYBSKXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:23:21 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:60369 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYBSKXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:23:20 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Gunter Ohrner <G.Ohrner@post.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vfat32 Free Cluster Count Update
References: <fp77bc$akv$1@ger.gmane.org>
Date: Tue, 19 Feb 2008 19:23:12 +0900
In-Reply-To: <fp77bc$akv$1@ger.gmane.org> (Gunter Ohrner's message of "Sat, 16
	Feb 2008 18:43:47 +0100")
Message-ID: <877ih1w8hb.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gunter Ohrner <G.Ohrner@post.rwth-aachen.de> writes:

> Doesn't the Linux vfat driver update the FAT32's free cluster summary count?
>
> Zweiblum:~# dosfsck /dev/sda11
> dosfsck 2.11, 12 Mar 2005, FAT32, LFN
> /dev/sda11: 2451 files, 28218/1918827 clusters
>
> Zweiblum:~# mount /dev/sda11 /mnt/win_daten/
>
> Zweiblum:~# cp /etc/motd /mnt/win_daten/
>
> Zweiblum:~# umount /mnt/win_daten/
>
> Zweiblum:~# dosfsck /dev/sda11
> dosfsck 2.11, 12 Mar 2005, FAT32, LFN
> Free cluster summary wrong (1890609 vs. really 1890608)
> 1) Correct
> 2) Don't correct
> ? ^C

This problem was introduced by it ignores a free cluster count (not
"usefree"). If we was not using "usefree" option, FAT doesn't trust the
"free cluster count" anymore.

So, it doesn't update until re-count.  Um.. yes, it's a bit
problem. Ah.. it can fix "we can trust now"-flag or something.

I'll dig it more, later. And for right now, please run "df" command, it
will fix free cluster count.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
