Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYEWJ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYEWJ3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYEWJ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:29:46 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37202 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbYEWJ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:29:45 -0400
Date: Fri, 23 May 2008 13:29:38 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steve French <smfrench@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: pagevecs of more than PAGEVEC_SIZE pages
Message-ID: <20080523092938.GA16915@2ka.mipt.ru>
References: <524f69650805221213i62488a4fk5a906b2726b9b96a@mail.gmail.com> <20080522225459.5a6f7acc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522225459.5a6f7acc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, May 22, 2008 at 10:54:59PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> > Now that various servers support processing larger than 64K file
> > writes, it would be helpful to have pagevecs that are larger than 14
> > pages (PAGEVEC_SIZE).so an array of more pages could be passed to
> > kernel_sendmsg (thus allowing writes larger than 56K, depending on
> > wsize - the server limit is currently 8MB)
> 
> You can pass multiple pagevecs into kernel_sendmsg?

kernel_sendmsg() requires iovecs, so each page will have to be mapped,
which can end up having too many slots in kmap table. I can reproduce
deadlock we talked about in POHMELFS thread with 100 highmem pages per
transaction on 32bit x86, so increasing pagevec noticebly can deadlock
CIFS too.

It could be great if CIFS moved to kernel_sendpage() instead, Steve?

-- 
	Evgeniy Polyakov
