Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZAFSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZAFSiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZAFSiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:38:12 -0500
Received: from brick.kernel.dk ([93.163.65.50]:29598 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZAFSiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:38:10 -0500
Date: Tue, 6 Jan 2009 19:37:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090106183704.GC32491@kernel.dk>
References: <20081224152841.GB13113@1wt.eu> <20090106183223.GA11964@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106183223.GA11964@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06 2009, Evgeniy Polyakov wrote:
> Hi Willy.
> 
> Unfortunately I can not work on this problem right now, but will do if
> things are not resolved after Jan 11 (long vacations will be finished in
> Russia and I will return to my test machines :) But right now I have
> one quesstion: I read several times your mail but still can not figure
> out if receiving or sending side is broken?
> 
> I.e. can you splice from socket into the file, check the file, and then
> splice to the another socket and check received data to find out which
> side is broken? Or did I just missed that in the problem description?
> 
> Thanks a lot for the test application, it will greatly help to resolve
> this issue.

I'll give this a spin tomorrow as well. A hunch tells me that this is
likely a page reuse issue, that splice is getting the reference to the
buffer dropped before the data has really been transmitted. IOW, the
page is likely fine reaching the ->sendpage() bit, but will be reused
before the data has actually been transmitted. So once you get that far,
other random data from that page is going out.

Just a guess, I'll try and reproduce this tomorrow!

-- 
Jens Axboe

