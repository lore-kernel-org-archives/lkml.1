Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbXD1TJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbXD1TJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXD1TJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:09:10 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:35935 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754052AbXD1TJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:09:09 -0400
Date: Sat, 28 Apr 2007 11:32:52 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Back to the future.
In-Reply-To: <20070428085000.GA3293@elf.ucw.cz>
Message-ID: <Pine.LNX.4.63.0704281130200.11638@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <200704280300.22604.rjw@sisk.pl>  <alpine.LFD.0.98.0704271801020.9964@woody.linux-foundation.org>
  <200704280344.49674.rjw@sisk.pl> <20070428085000.GA3293@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Pavel Machek wrote:

>>
>> We freeze user space processes for the reasons that you have quoted above.
>>
>> Why we freeze kernel threads in there too is a good question, but not for me to
>> answer.  I don't know.  Pavel should know, I think.
>
> We do not want kernel threads running:
>
> a) they may hold some locks and deadlock suspend
>
> b) they may do some writes to disk, leading to corruption
>
> We could solve a) by carefully auditing suspend lock usage to make
> sure deadlocks are impossible even with kernel threads running.

remember that we are doing suspend-to-disk, after we do the snapshot we will be 
doing a shutdown. that should simplify the locking issues

David Lang
