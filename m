Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYKQSy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYKQSy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKQSyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:54:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38222 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbYKQSys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:54:48 -0500
Message-ID: <4921BDC5.4090303@redhat.com>
Date: Mon, 17 Nov 2008 13:53:57 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] vmscan: fix get_scan_ratio comment
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081115210039.537f59f5.akpm@linux-foundation.org> <alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org> <49208E9A.5080801@redhat.com> <20081116204720.1b8cbe18.akpm@linux-foundation.org> <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com> <2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com> <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.0811170802010.3468@nehalem.linux-foundation.org> <alpine.LFD.2.00.0811170830320.3468@nehalem.linux-foundation.org> <4921A1AF.1070909@redhat.com> <alpine.LFD.2.00.0811170904160.3468@nehalem.linux-foundation.org> <4921A706.9030501@redhat.com> <alpine.LFD.2.00.0811170932390.3468@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811170932390.3468@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> Anyway, without quoting, the thing is - your fix isn't any better. The 
> more interesting part is how the fractions get combined, and that is 
> indeed approximately "anon% = anon / (anon + file)".

Well, the "anon" and "file" in that calculation are the
scanned/rotated ratios for anon and file pages, not the
sizes of the lists.

> So you in many ways made the comment worse. It wasn't good before, but 
> it's still not good, and now it comments on the part that isn't even 
> interesting (ie it comments the _trivial_ fractional part)

How about something like the following: ?

/*
  * The amount of pressure on anon vs file pages is inversely
  * proportional to the fraction of recently scanned pages on
  * each list that were recently referenced and in active use.
  */

(I'll mail the next patches out with claws-mail - silly thunderbird)

-- 
All rights reversed.
