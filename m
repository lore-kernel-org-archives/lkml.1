Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZJ2Ifr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZJ2Ifr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZJ2Ifq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:35:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3417 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZJ2Ifq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:35:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ljpvlFVU/dTgSUoOooIAqDH/pIzXwxi+z0kPxkXa7QYJpma8kVZ0MonxPDwywhoiD
	I41kUIZdDMiFeoXg329lg==
Date: Thu, 29 Oct 2009 01:35:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vedran.furac@gmail.com
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <4AE9068B.7030504@gmail.com>
Message-ID: <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
 <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com>
 <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <4AE846E8.1070303@gmail.com> <alpine.DEB.2.00.0910281307370.23279@chino.kir.corp.google.com>
 <4AE9068B.7030504@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Vedran Furac wrote:

> > We would know if you posted the data.
> 
> I need to find some free time to destroy a session on a computer which I
> use for work. You could easily test it yourself also as this doesn't
> happen only to me.
> 
> Anyways, here it is... this time it started with ntpd:
> 
> http://pastebin.com/f3f9674a0
> 

That oom log shows 12 ooms but no tasks actually appear to be getting 
killed (there're no "Killed process 1234 (task)" found).  Do you have any 
idea why?

Anyway, as I posted in response to KAMEZAWA-san's patch, the change to 
get_mm_rss(mm) prefers Xorg more than the current implementation.

>From your log at the link above:

total_vm
669624 test
195695 krunner
187342 krusader
168881 plasma-desktop
130562 ktorrent
127081 knotify4
125881 icedove-bin
123036 akregator

rss
668738 test
42191 Xorg
30761 firefox-bin
13331 icedove-bin
10234 ktorrent
9263 akregator
8864 plasma-desktop
7532 krunner

Can you explain why Xorg is preferred as a baseline to kill rather than 
krunner in your example?

Thanks.
