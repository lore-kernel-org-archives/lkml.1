Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXAYRks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXAYRks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030484AbXAYRks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:40:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:1818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030481AbXAYRkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ttf+KiuiIm1oK5+9YTb1KjnVs9pRJBC4PlPbJ+52WhAt5F1e5lf3G51zxpnd5FDQHP+2advhY9FZCA6iiN98GCTxzc1FVUGPhl41sAhEhM22qQk2bXwPydL8KGQTieV91FypD0idGf4DEij3ImxpfXc94t4erD8DFtq1+31zIFU=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: O_DIRECT question
Date: Thu, 25 Jan 2007 18:38:30 +0100
User-Agent: KMail/1.8.2
Cc: Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701242215.47777.vda.linux@googlemail.com> <45B8D041.8050507@cfl.rr.com>
In-Reply-To: <45B8D041.8050507@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701251838.30796.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 January 2007 16:44, Phillip Susi wrote:
> Denis Vlasenko wrote:
> > I will still disagree on this point (on point "use O_DIRECT, it's faster").
> > There is no reason why O_DIRECT should be faster than "normal" read/write
> > to large, aligned buffer. If O_DIRECT is faster on today's kernel,
> > then Linux' read()/write() can be optimized more.
> 
> Ahh but there IS a reason for it to be faster: the application knows 
> what data it will require, so it should tell the kernel rather than ask 
> it to guess.  Even if you had the kernel playing vmsplice games to get 
> avoid the copy to user space ( which still has a fair amount of overhead 
> ), then you still have the problem of the kernel having to guess what 
> data the application will require next, and try to fetch it early.  Then 
> when the application requests the data, if it is not already in memory, 
> the application blocks until it is, and blocking stalls the pipeline.
> 
> > (I hoped that they can be made even *faster* than O_DIRECT, but as I said,
> > you convinced me with your "error reporting" argument that reads must still
> > block until entire buffer is read. Writes can avoid that - apps can do
> > fdatasync/whatever to make sync writes & error checks if they want).
> 
> 
> fdatasync() is not acceptable either because it flushes the entire file.

If you opened a file and are doing only O_DIRECT writes, you
*always* have your written data flushed, by each write().
How is it different from writes done using
"normal" write() + fdatasync() pairs?

>   This does not allow the application to control the ordering of various 
> writes unless it limits itself to a single write/fdatasync pair at a 
> time.  Further, fdatasync again blocks the application.

Ahhh shit, are you saying that fdatasync will wait until writes
*by all other processes* to thios file will hit the disk?
Is that thue?

--
vda
