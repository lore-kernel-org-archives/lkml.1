Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbXKSPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbXKSPsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXKSPsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:48:06 -0500
Received: from smtp.nokia.com ([192.100.122.230]:42257 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXKSPsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:48:05 -0500
X-Greylist: delayed 2449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2007 10:48:05 EST
Message-ID: <4741A592.3080908@yandex.ru>
Date: Mon, 19 Nov 2007 17:02:42 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: is the inode an orphan?
References: <47179CAE.6010806@yandex.ru> <20071018180152.GO8181@ftp.linux.org.uk> <471857B1.8090709@yandex.ru> <20071030141004.GA27039@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071030141004.GA27039@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Nov 2007 15:02:43.0588 (UTC) FILETIME=[3CB72440:01C82ABD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jan Kara wrote:
>> In our FS when we're in ->unlink() and i_nlink becomes 0, we have to record 
>> this inode in the table of orphans, and remove it from there in 
>> ->delete_inode(). This is needed to be able to dispose of orphans in case 
>> of an unclean reboot on the next mount. AFAIK, ext3 has something similar. 
>> I just figured that this could be optimized - in most cases 
>> ->delete_inode() is called right after ->unlink(), and I wanted to avoid 
>> putting the inode to the orphan table in those cases.
>   Yes, ext3 has something similar. But actually ext3 would have to insert
> inode in the orphan list anyway - in delete_inode we do truncate and
> for it we also insert the inode into the orphan list because truncate
> can be too large to fit into a single transaction.

Ok, thanks for this point.

>   Hmm, I'm just not sure whether unlink cannot somehow race with open
> (at least I don't see any lock that would prevent open while unlink is
> in progress)...

And this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
