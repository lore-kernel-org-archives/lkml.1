Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbZLHPgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbZLHPgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbZLHPgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:36:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:48873 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbZLHPfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:35:51 -0500
Subject: Re: [RFC,PATCH 14/14] utrace core
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
In-Reply-To: <20091208150417.GA11883@redhat.com>
References: <20091124200220.GA5828@redhat.com>
	 <1259697242.1697.1075.camel@laptop> <20091201220847.GA25400@redhat.com>
	 <1260210877.3935.594.camel@laptop>  <20091208150417.GA11883@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 16:35:34 +0100
Message-ID: <1260286534.3935.1511.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 16:04 +0100, Oleg Nesterov wrote:
> The
> problem is, this code was developed out-of-tree. That is why we would
> like to merge it asap, then do other changes which could be easily
> reviewed.
> 
> Now, do you really mean we should throw out the working code, rewrite
> it avoiding these barriers, and resubmit? Sure, everything is possible.
> But this means another round of out-of-tree development with unclear
> results. 

Out-of-tree development is bad, it having taken lot of effort is no
excuse for merging ugly.

Now, I'm not against barriers at all, but code that is as barrier heavy
as this, with such bad comments and no clear indication it was actually
worth using so many barriers make me wonder.

Barriers aren't free either, and having multiple such things in quick
succession isn't nessecarily faster than a lock, but much less obvious.



