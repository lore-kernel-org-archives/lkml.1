Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbYBRQRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbYBRQRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYBRQRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:17:14 -0500
Received: from mail.syneticon.net ([213.239.212.131]:49989 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbYBRQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:17:12 -0500
Message-ID: <47B9AF77.9040702@wpkg.org>
Date: Mon, 18 Feb 2008 17:16:55 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Tomasz Chmielewski <mangoo@wpkg.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47B99E0C.8020706@wpkg.org> <20080218151632.GD25098@mit.edu>
In-Reply-To: <20080218151632.GD25098@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso schrieb:

>> Are there better choices than ext3 for a filesystem with lots of hardlinks? 
>> ext4, once it's ready? xfs?
> 
> All filesystems are going to have problems keeping inodes close to
> directories when you have huge numbers of hard links.
> 
> I'd really need to know exactly what kind of operations you were
> trying to do that were causing problems before I could say for sure.
> Yes, you said you were removing unneeded files, but how were you doing
> it?  With rm -r of old hard-linked directories?

Yes, with rm -r.


> How big are the
> average files involved?  Etc.

It's hard to estimate the average size of a file. I'd say there are not 
many files bigger than 50 MB.

Basically, it's a filesystem where backups are kept. Backups are made 
with BackupPC [1].

Imagine a full rootfs backup of 100 Linux systems.

Instead of compressing and writing "/bin/bash" 100 times for each 
separate system, we do it once, and hardlink. Then, keep 40 copies back, 
and you have 4000 hardlinks.

For individual or user files, the number of hardlinks will be smaller of 
course.

The directories I want to remove have usually a structure of a "normal" 
Linux rootfs, nothing special there (other than most of the files will 
have multiple hardlinks).


I noticed using write back helps a tiny bit, but as dm and md don't 
support write barriers, I'm not very eager to use it.


[1] http://backuppc.sf.net
http://backuppc.sourceforge.net/faq/BackupPC.html#some_design_issues



-- 
Tomasz Chmielewski
http://wpkg.org

