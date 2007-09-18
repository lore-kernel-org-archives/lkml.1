Return-Path: <linux-kernel-owner+w=401wt.eu-S1761221AbXIRRlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221AbXIRRlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbXIRRl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:41:27 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:38329 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759358AbXIRRl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:41:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0UJBGUg06AD/7FMpWnLheGG5va7cA82EuqV9C/GS61F8gWO95QsBHsoWAEGQZDWJDWebLnIc0g8hrrfckpE70CUXl03Izq2yVl+AKInXtXSykXmJgX29bX6d8v3S5ZoJU3RppCGidUCioXngHaUu6ziQsQuojZyxH46eX0Oxeqk=  ;
X-YMail-OSG: bxiHMG0VM1lhfC_yzrIIVsbThZessjUka3Grg10rrMEvUQJBwqcjhIffgvM8xrwdXMpbE90Jog--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] mm: use pagevec to rotate reclaimable page
Date: Tue, 18 Sep 2007 11:29:50 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <6.0.0.20.2.20070907113025.024dfbb8@172.19.0.2> <20070913193711.ecc825f7.akpm@linux-foundation.org> <6.0.0.20.2.20070918193944.038e2ea0@172.19.0.2>
In-Reply-To: <6.0.0.20.2.20070918193944.038e2ea0@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709181129.50253.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 20:41, Hisashi Hifumi wrote:
> I modified my patch based on your comment.
>
> At 11:37 07/09/14, Andrew Morton wrote:
>  >So I do think that for safety and sanity's sake, we should be taking a
>  > ref on the pages when they are in a pagevec.  That's going to hurt your
>  > nice performance numbers :(
>
> I did ping test again to observe performance deterioration caused by taking
> a ref.
>
> 	-2.6.23-rc6-with-modifiedpatch
> 	--- testmachine ping statistics ---
> 	3000 packets transmitted, 3000 received, 0% packet loss, time 53386ms
> 	rtt min/avg/max/mdev = 0.074/0.110/4.716/0.147 ms, pipe 2, ipg/ewma
> 17.801/0.129 ms
>
> The result for my original patch is as follows.
>
> 	-2.6.23-rc5-with-originalpatch
> 	--- testmachine ping statistics ---
> 	3000 packets transmitted, 3000 received, 0% packet loss, time 51924ms
> 	rtt min/avg/max/mdev = 0.072/0.108/3.884/0.114 ms, pipe 2, ipg/ewma
> 17.314/0.091 ms
>
>
> The influence to response was small.

It would be interesting to test -mm kernels. They have a patch which reduces
zone lock contention quite a lot.

I think your patch is a nice idea, and with less zone lock contention in other
areas, it is possible that it might produce a relatively larger improvement.
