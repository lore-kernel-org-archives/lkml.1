Return-Path: <linux-kernel-owner+w=401wt.eu-S1751424AbXBMW6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbXBMW6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXBMW6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:58:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59673 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbXBMW6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:58:21 -0500
Date: Tue, 13 Feb 2007 14:57:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, arjan@infradead.org, hch@infradead.org,
       akpm@zip.com.au, alan@lxorguk.ukuu.org.uk, drepper@redhat.com,
       zach.brown@oracle.com, johnpol@2ka.mipt.ru, davem@davemloft.net,
       bcrl@kvack.org, suparna@in.ibm.com, davidel@xmailserver.org,
       tglx@linutronix.de
Subject: Re: [patch 05/11] syslets: core code
Message-Id: <20070213145709.323a6505.akpm@linux-foundation.org>
In-Reply-To: <20070213222443.GH22104@elte.hu>
References: <20060529212109.GA2058@elte.hu>
	<20070213142035.GF638@elte.hu>
	<p73bqjxhcnl.fsf@bingen.suse.de>
	<20070213222443.GH22104@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Feb 2007 23:24:43 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > If it's only a few pages you don't need any resource accounting. If 
> > it's more then it's nasty to steal the users quota. I think plain 
> > gup() would be better.
> 
> get_user_pages() would have to be limited in some way - and i didnt want 
> to add yet another wacky limit thing - so i just used the already 
> existing mlock() infrastructure for this. If Oracle wants to set up a 10 
> MB ringbuffer, they can set the PAM resource limits to 11 MB and still 
> have enough stuff left. And i dont really expect GPG to start using 
> syslets - just yet ;-)
> 
> a single page is enough for 1024 completion pointers - that's more than 
> enough for most purposes - and the default mlock limit is 40K.

So if I have an application which instantiates a single mlocked page
for this purpose, I can only run ten of them at once, and any other
mlock-using process which I'm using starts to mysteriously fail.

It seems like a problem to me..
