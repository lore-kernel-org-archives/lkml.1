Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186AbXAZXTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbXAZXTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 18:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXAZXTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 18:19:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:58589 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbXAZXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 18:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jBevofX6JGuPpqMKIwWL0oGcilSa8c0SEt0CTJs8bPf/QX+QBJn5CtsASYG0mIo8uxev6P32rESnyEb2jtbPhapC+AIA/0/1TAEPAQIFWfjQ1NTThpRNNVWra6j+UM6podAonXVcZoO/rtsawhjPFc3F4xwwoSuOap0djBk/sh4=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: O_DIRECT question
Date: Sat, 27 Jan 2007 00:16:46 +0100
User-Agent: KMail/1.8.2
Cc: Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701252211.39017.vda.linux@googlemail.com> <45BA34EE.4050402@cfl.rr.com>
In-Reply-To: <45BA34EE.4050402@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701270016.46951.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 18:05, Phillip Susi wrote:
> Denis Vlasenko wrote:
> > Which shouldn't be true. There is no fundamental reason why
> > ordinary writes should be slower than O_DIRECT.
> 
> Again, there IS a reason:  O_DIRECT eliminates the cpu overhead of the 
> kernel-user copy,

You assume that ordinary read()/write() is *required* to do the copying.
It doesn't. Kernel is allowed to do direct DMAing in this case too.

> and when coupled with multithreading or aio, allows  
> the IO queues to be kept full with useful transfers at all times.

Again, ordinary I/O is no different. Especially on fds opened with O_SYNC,
write() will behave very similarly to O_DIRECT one - data is guaranteed
to hit the disk before write() returns.

> Normal read/write requires the kernel to buffer and guess access

No it doesn't *require* that.

> patterns correctly to perform read ahead and write behind perfectly to 
> keep the queues full.  In practice, this does not happen perfectly all 
> of the time, or even most of the time, so it slows things down.

So lets fix the kernel for everyone's benefit intead of "give us
an API specifically for our needs".
--
vda
