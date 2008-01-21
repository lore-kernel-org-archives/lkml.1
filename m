Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYAUH4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYAUH4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 02:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbYAUH4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 02:56:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:49230 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbYAUH4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 02:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=w+j015VapU7bgGQpPw2b2NbWxhr4lT2bQIwfzokE9/dygDP/zZb5Si7BPJ4mGrt00C9oT88f/CG2SLbHehMVLr+tn1L0/fQdrfWGZf2Bkt0XjuaymzuWU0RmGgl01imXyfJjU0FnQ+3+xoCpLK3d+4++xp72rI9LAIxymyZJ3g0=
Message-ID: <4794501E.90306@gmail.com>
Date: Mon, 21 Jan 2008 16:56:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
References: <200801140019.20668.g.chulkov@jacobs-university.de>	<20080115025435.1e21b703.akpm@linux-foundation.org> <20080115113552.75731bf8@lxorguk.ukuu.org.uk>
In-Reply-To: <20080115113552.75731bf8@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> [ 9031.028000] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
>>> frozen
>>> [ 9031.028000] ata1.00: cmd c8/00:08:90:ca:ce/00:00:00:00:00/e0 tag 0 cdb 0x0 
>>> data 4096 in
>>> [ 9031.028000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
>>> (timeout)
> 
> We got bored of waiting for the drive to respond to our request. I still
> think we have the timeouts too short or are accounting queue time
> somewhere we shouldn't as there a few other examples where we don't allow
> long enough for a drive to retry out and fail with a media error on a bad
> sector.

Hmm.. That's not what I hear from Mark and vendor contacts.  They say
30secs is more than enough.  I actually am thinking about reducing it to
15secs (not for FLUSH of course) as many SFF controllers report
transmission failure as timeouts.  Of course, if we're ticking the timer
while the command is not in flight, that's a bug.  If there are cases
where 30 secs isn't enough, can you please point me to those reports?

Thanks.

-- 
tejun
