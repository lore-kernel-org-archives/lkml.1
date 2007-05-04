Return-Path: <linux-kernel-owner+w=401wt.eu-S1031365AbXEDIKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031365AbXEDIKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031366AbXEDIK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:10:29 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54745 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031361AbXEDIJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:09:59 -0400
Date: Fri, 4 May 2007 10:09:06 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rewrite the MAJOR() macro as a call to imajor().
In-Reply-To: <20070503231814.e12ad2d7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705041008180.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
 <20070503231814.e12ad2d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 23:18, Andrew Morton wrote:
>>  	struct inode *i = file->f_mapping->host;
>> 
>> -	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
>> +	return i && S_ISBLK(i->i_mode) && imajor(i) == LOOP_MAJOR;
>>  }
>
>there's no runtime change, and I count a couple hundred MAJORs in the tree.

Why do we even have imajor() if all it does is calling the MAJOR()
macro?


Jan
-- 
