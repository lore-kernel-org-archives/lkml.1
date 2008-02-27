Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYB0U0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYB0U0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbYB0U0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:26:07 -0500
Received: from mail.syneticon.net ([213.239.212.131]:35130 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbYB0U0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:26:05 -0500
Message-ID: <47C5C74D.3050508@wpkg.org>
Date: Wed, 27 Feb 2008 21:25:49 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andreas Dilger <adilger@sun.com>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47C54773.4040402@wpkg.org> <20080227200335.GB9331@webber.adilger.int>
In-Reply-To: <20080227200335.GB9331@webber.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger schrieb:
> I'm CCing the linux-raid mailing list, since I suspect they will be
> interested in this result.
> 
> I would suspect that the "journal guided RAID recovery" mechanism
> developed by U.Wisconsin may significantly benefit this workload
> because the filesystem journal is already recording all of these
> block numbers and the MD bitmap mechanism is pure overhead.

Also, using anticipatory IO scheduler seems to be the best option for an 
array with lots of seeks and random reads and writes (quite 
surprisingly, closely followed by NOOP - both were behaving much better 
than deadline or CFQ).

Here are some numbers I posted to BackupPC mailing list:

http://thread.gmane.org/gmane.comp.sysutils.backup.backuppc.general/14009



-- 
Tomasz Chmielewski
http://wpkg.org
