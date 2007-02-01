Return-Path: <linux-kernel-owner+w=401wt.eu-S1422855AbXBANTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422855AbXBANTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422863AbXBANTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:19:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57928 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422855AbXBANTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:19:13 -0500
Date: Thu, 1 Feb 2007 13:19:04 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070201131903.GA24683@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
	linux-kernel@vger.kernel.org, linux-aio@kvack.org,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070201130234.GA15257@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 02:02:34PM +0100, Ingo Molnar wrote:
> what i dont really like /the particular/ concept above - the 
> introduction of 'fibrils' as a hard distinction of kernel threads. They 
> are /almost/ kernel threads, but still by being different they create 
> alot of duplication and miss out on a good deal of features that kernel 
> threads have naturally.
> 
> It kind of hurts to say this because i'm usually quite concept-happy - 
> one can easily get addicted to the introduction of new core kernel 
> concepts :-) But i really, really think we dont want to do fibrils but 
> we want to do kernel threads, and i havent really seen a discussion 
> about why they shouldnt be done via kernel threads.

I tend to agree.  Note that there is one thing we should be doing one
one day (not only if we want to use it for aio) is to make kernel threads
more lightweight.  Thereéis a lot of baggae we keep around in task_struct
and co that only makes sense for threads that have a user space part and
aren't or shouldn't be needed for a purely kernel-resistant thread.
