Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXKBNzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXKBNzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbXKBNzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:55:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41949 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbXKBNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:54:59 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <3ae72650711020650l37870e45yb853f888b4807116@mail.gmail.com>
References: <1193410087.6914.34.camel@twins>
	 <1193412836.27652.11.camel@twins> <1193414147.2431.35.camel@lov.site>
	 <1193429066.5648.35.camel@lappy> <1193447889.5648.44.camel@lappy>
	 <20071027024033.GB29039@kroah.com> <1193474399.27652.15.camel@twins>
	 <20071027160203.GA5709@kroah.com> <1193519317.5776.14.camel@lov.site>
	 <1194009359.27652.377.camel@twins>
	 <3ae72650711020650l37870e45yb853f888b4807116@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 14:54:51 +0100
Message-Id: <1194011691.27652.382.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 14:50 +0100, Kay Sievers wrote:
> On Nov 2, 2007 2:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Thanks for the help so far, however we're still not quite there.
> >
> > The below patch still has the funny 20 character name limit. Is there a
> > good reason its a char array like this, and not just a char * to a kstr?
> > The code does kstrdup all over the place, I can't imagine why suddenly
> > limiting it to 20 chars seems like a good idea.
> 
> You are absolutely right, it doesn't make any sense. The 20 char limit
> is bad, but really,
> having the name duplicated in the device structure, while the name is
> already in the
> embedded kobject, is really bad.
> 
> Greg recently got rid of the 20 chars in the kobject, now we need to fix the
> devices to completely get rid of the static bus_id string array, and just set
> the kobject name directly.
> It's all long overdue to fix things like this in the driver core -
> it's such a mess. After the
> kset cleanup Greg and I are doing currently, we will remove that silly limit.

Ok, great!

Could I ask you to nudge me awake once those patches hit a git tree
somewhere?

> Hmm, regardless of the limit, isn't there a better device name than a memory
> address of a kernel structure. :)

Yes there is, Trond already suggested a proper replacement, however so
far I've been just trying to get it to work before trying to make it
pretty.

Will implement Trond's suggestion while you and Greg eradicate this 20
byte thing :-)

