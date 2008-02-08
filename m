Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbYBHKub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbYBHKub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932159AbYBHKuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:50:16 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56232 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYBHKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:50:14 -0500
Message-Id: <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Theodore Tso" <tytso@MIT.EDU>, <linux-ext4@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 8 Feb 2008 19:48:25 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ted wrote:
> And I do agree that we probably should just implement this in
> filesystem independent way, in which case all of the filesystems that
> support this already have super_operations functions
> write_super_lockfs() and unlockfs().
> 
> So if this is done using a new system call, there should be no
> filesystem-specific changes needed, and all filesystems which support
> those super_operations method functions would be able to provide this
> functionality to the new system call.

OK I would like to implement the freeze feature on VFS
as the filesystem independent ioctl so that it can be
available on filesystems that have already had write_super_lockfs()
and unlockfs().
The usage for the freeze ioctl is the following.
  int ioctl(int fd, int FIFREEZE, long *timeval);
    fd:file descriptor of mountpoint
    FIFREEZE:request cord for freeze
    timeval:timeout period (second)

And the unfreeze ioctl is the following.
  int ioctl(int fd, int FITHAW, NULL);
    fd:file descriptor of mountpoint
    FITHAW:Request cord for unfreeze

I think we need the timeout feature which thaws the filesystem
after lapse of specified time for a fail-safe in case the freezer
accesses the frozen filesystem and causes a deadlock.
I intend to implement the timeout feature on VFS.
(This is realized by registering the delayed work which calls
thaw_bdev() to the delayed work queue.)

Any comments are very welcome.

Cheers, Takashi
