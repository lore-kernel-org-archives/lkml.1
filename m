Return-Path: <linux-kernel-owner+w=401wt.eu-S1750852AbZIHO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750852AbZIHO3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbZIHO3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:29:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52629 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZIHO3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:29:18 -0400
Subject: [PATCH take 3][RFC] fat: Save FAT root directory timestamps to
	volume label
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <87fxclmhxy.fsf@devron.myhome.or.jp>
	 <1248691635.4618.43.camel@jorg-desktop>
	 <87ljmas5ym.fsf@devron.myhome.or.jp>
	 <1249375357.5736.53.camel@jorg-desktop>
	 <87zlafswci.fsf@devron.myhome.or.jp>
In-Reply-To: <87zlafswci.fsf@devron.myhome.or.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2009 17:28:51 +0300
Message-Id: <1252420131.5782.2.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Sep 2009 14:28:52.0688 (UTC) FILETIME=[B06DA500:01CA3090]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 12:32 +0200, ext OGAWA Hirofumi wrote: 
> Jörg Schummer <ext-jorg.2.schummer@nokia.com> writes:
> 
> > On Mon, 2009-07-27 at 13:47 +0200, ext OGAWA Hirofumi wrote:
> >> Jörg Schummer <ext-jorg.2.schummer@nokia.com> writes:
> >
> >> BTW, the patch has several bugs. fat_get_label_entry() doesn't check
> >> IS_FREE(), is it right? fat_create_label_entry() doesn't initialize all
> >> timestamp in the case of msdos. spin_lock() usage is wrong. and more...
> >
> > After reviewing the patch again, I did notice some additional problems
> > (I suppose that was the "and more..."). If and when I have time again, I
> > might take a closer look at it again.
> >
> > Thanks for your help until now!

Hello,

on the off-chance that somebody would like to use this mechanism, I did
a 3rd take of the patch. I tried to fix the problems of the previous
patch and additionally added the functionality to correct the root dir
timestamp's mtime and atime somewhat based on contained directory
entries' ctime.

Any comments are welcome, but especially I'd like to ask if it is safe /
good / doable to call 

  remove_inode_hash(inode);
  fat_attach(inode, i_pos);
  insert_inode_hash(inode);

inside fat_write_inode .

Thanks for any feedback!
Jörg


