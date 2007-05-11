Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXEKKAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXEKKAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 06:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbXEKKAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 06:00:32 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:63205 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbXEKKAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 06:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YFtlo635PQoLIjWpZ7M2npMC2FUh7qBKudXohQ7Y6aypQfbzksFuQ1bXVVxskBcKfV7Knd+RD1SCRlw+5G9HxEe2qjF40d9Wx90DLmho+7XCewsUI50Cu86E3zreWpjuRq+UI4XVy1kak+Bm2jqAP0ETgFOZbXLD9fp1G9qFPiE=
Message-ID: <6880bed30705110300i77033b7bgc111b0e165b78097@mail.gmail.com>
Date: Fri, 11 May 2007 12:00:30 +0200
From: "Bas Westerbaan" <bas.westerbaan@gmail.com>
To: "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: Conveying memory pressure to userspace?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4643CCDF.7060608@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6880bed30705101756nb5bd0c5s97935b97d07f846a@mail.gmail.com>
	 <4643CCDF.7060608@mbligh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The prev_priority field in the zoneinfo stuff is more useful for
> memory pressure. I'm playing with making a blocking callback that
> can wake someone up when this gets down to a certain priority level
> (prio=12 => everything's rosy, prio=0 => we're in deep shit).

Ah, I see.  This, however, doesn't make sharing fair yet.

Take for instance two SQL servers.  Both want as much cache.  At a
certain moment they'll both have allocated just enough to keep the
last_priority to a constant.

When one has a slightly lesser constant than the other, that one will
keep allocating to get it down to that value whereas the other will
keep freeing to get up to his constant.

Even when they've got the same pressure they strive for then when some
pressure is releaved, it's first come first serve, which isn't really
fair.



Let applications register the amount of cache they are using (proc
entry, new madvise flag?) and let them register a priority.  Then the
kernel will keep track of a factor of fairness (<1: not greedy enough;
1> too greedy.)[1].  What about adding a callback when this value
deviates a certain amount (<0.8, >1.2)?



-- 
Bas Westerbaan
GPG 99BA289B | SINP bas@w-nz.com
http://blog.w-nz.com/
