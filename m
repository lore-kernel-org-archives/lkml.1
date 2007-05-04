Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbXEDLnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbXEDLnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXEDLnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:43:02 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45338 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbXEDLnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:43:00 -0400
Date: Fri, 4 May 2007 13:42:09 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rewrite the MAJOR() macro as a call to imajor().
In-Reply-To: <Pine.LNX.4.64.0705040410390.20834@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705041340310.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
 <20070503231814.e12ad2d7.akpm@linux-foundation.org>
 <Pine.LNX.4.61.0705041008180.18504@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0705040410390.20834@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 04:14, Robert P. J. Day wrote:
>> On May 3 2007 23:18, Andrew Morton wrote:
>> >>  	struct inode *i = file->f_mapping->host;
>> >>
>> >> -	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
>> >> +	return i && S_ISBLK(i->i_mode) && imajor(i) == LOOP_MAJOR;
>> >>  }
>> >
>> >there's no runtime change, and I count a couple hundred MAJORs in the tree.
>>
>> Why do we even have imajor() if all it does is calling the MAJOR()
>> macro?
>
>  i'm guessing it's to hide the underlying implementation of
>extracting the major/minor numbers from an inode, in case that
>implementation ever changes, which strikes me as perfectly reasonable.

How often has the implementation changed? I think i_rdev has been
there for a looong time. But yes, doing the MAJOR => imajor conversion
is preferable. Because you don't need the struct declaration for inode
then, and may omit to #include <linux/fs.h>. (Other things may need
fs.h so it's a bit of a corner case.)

>  all i was doing was standardizing the small handful of holdouts.

Please continue, this was not a rant :)



Jan
-- 
