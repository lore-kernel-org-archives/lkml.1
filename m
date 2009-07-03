Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZGCCh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZGCCh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZGCChw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:37:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65152 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbZGCChv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:37:51 -0400
Message-ID: <4A4D6F38.8040602@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 10:38:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Benjamin Blum <bblum@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: fix pid namespace bug, fix
References: <4A4D61C7.4090409@cn.fujitsu.com> <20090703024304.GA27802@hallyn.com>
In-Reply-To: <20090703024304.GA27802@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  	cp->cgrp = cgrp;
>> -	cp->pid_ns = pid_ns;
>> +	cp->ns = ns;
> 
> Why not just do
> 
> 	cp->ns = get_pid_ns(ns);
> 
> here instead of getting and putting at (1) and (2) ?
> 
> Both are correct, but this way will take a bit more
> work to verify every time someone comes to look at this.
> 
> In fact, (just noticed) yours isn't right, because at (3) you
> will leak the pidns reference.
> 

My bad. :(

I did the quick fix without thinking it more.

And I noticed seemingly the similar bug exists in Benjamin's patch...


