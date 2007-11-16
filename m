Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbXKPSb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbXKPSb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbXKPSbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:31:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXKPSbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:31:44 -0500
Message-ID: <473DE1B4.8090703@zytor.com>
Date: Fri, 16 Nov 2007 10:30:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
CC: Stefan Monnier <monnier@iro.umontreal.ca>, linux-kernel@vger.kernel.org
Subject: Re: Treat disk space like memory space
References: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org> <75b66ecd0711151624n476d2e83xd1acbb23a5bffcf0@mail.gmail.com>
In-Reply-To: <75b66ecd0711151624n476d2e83xd1acbb23a5bffcf0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On Nov 15, 2007 5:24 PM, Stefan Monnier <monnier@iro.umontreal.ca> wrote:
>> [ I realize this is probably better implemented outside of the kernel, but
>>   it seems like it might be of interest here.  Please redirect me to
>>   a more appropriate place if you can think of one (other than
>>   /dev/null that is).  ]
> 
> It would require some kernel support to reclaim the storage from the
> caching application rather than returning -ENOSPC when a "normal" app
> needs the storage.  Even if you make the caching app free the space by
> itself you need a kernel mechanism to signal it when this happens.
> 

In particular, you need a way to hold off the "real" application until 
disk reclaim is done.

If you do it purely in userspace (asynchronously) then it's subject to 
ENOSPC while the reclaimer runs.

This, by the way, has been discussed on and off -- often in the context 
of undelete (which is an identical problem.)  The problem usually is 
that performance of real storage users suffer because of locality 
issues.  However, flash storage doesn't have locality requirements...

	-hpa

