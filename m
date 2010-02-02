Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0BBUdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:33:31 -0500
Received: from mail.lang.hm ([64.81.33.126]:43703 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0BBUda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:33:30 -0500
Date: Tue, 2 Feb 2010 11:59:03 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Olivier Galibert <galibert@pobox.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] readahead: dont do start-of-file readahead after
 lseek()
In-Reply-To: <alpine.LFD.2.00.1002021111240.3664@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1002021157280.3707@asgard.lang.hm>
References: <20100202152835.683907822@intel.com> <20100202153317.644170708@intel.com> <20100202181321.GB75577@dspnet.fr.eu.org> <alpine.LFD.2.00.1002021037110.3664@localhost.localdomain> <20100202184831.GD75577@dspnet.fr.eu.org>
 <alpine.LFD.2.00.1002021111240.3664@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010, Linus Torvalds wrote:

> Rememebr: read-ahead is about filling the empty IO spaces _between_ reads,
> and turning many smaller reads into one bigger one. If you only have a
> single big read, read-ahead cannot help.
>
> Also, keep in mind that read-ahead is not always a win. It can be a huge
> loss too. Which is why we have _heuristics_. They fundamentally cannot
> catch every case, but what they aim for is to do a good job on average.

as a note from the field, I just had an application that needed to be 
changed because it did excessive read-ahead. it turned a 2 min reporting 
run into a 20 min reporting run because for this report the access was 
really random and the app forced large read-ahead.

David Lang
