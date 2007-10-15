Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXJOI1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXJOI1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbXJOI1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:27:36 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:32247 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752953AbXJOI1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:27:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bQ0agfSMHoSbEK7/+1USgsuS8j0lMx4htZrhrSK0NhYeXBtBz0cU44Q7URJOT2wDjfbloA/jMsoVUse1iIJxPN09/v+Mia3e2rvYqU3ZygjWDmG+ZMj44QnNvXkLt9W5MZPUWZoXi4ik7+5Y/ugDpgzzn9TvkEUkSAi4GCxYmI8=  ;
X-YMail-OSG: DzVp6lEVM1nbVjHSbKsu9yQtk1zxKDxhejODzjP8BtLLb8srIbM._0UaPZdqwuIlZBORc_8l8Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rob Landley <rob@landley.net>
Subject: OOM killer gripe (was Re: What still uses the block layer?)
Date: Mon, 15 Oct 2007 23:37:44 +1000
User-Agent: KMail/1.9.5
Cc: Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
References: <200710112011.22000.rob@landley.net> <20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net>
In-Reply-To: <200710150304.00901.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152337.45252.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 18:04, Rob Landley wrote:
> On Sunday 14 October 2007 8:45:03 pm Theodore Tso wrote:

> > > excuse for conflating different categories of devices in the first
> > > place.
> >
> > See the thinkpad Ultrabay drive example above.
>
> Last week I drove my laptop so deep into swap (with a "make -j" on qemu)
> that after half an hour trying to repaint my kmail window, it locked solid.
> Again.  You'd think the oom killer would come to the rescue, but it didn't.
> Maybe Ubuntu disabled it.  I have _2_gigs_ of ram in this sucker, on a
> stock Ubuntu 7.04 install (with the "upgrade all" tab pressed a few times),
> and yet I managed to make it swap itself to death one more time.
>
> Virtual memory isn't perfect.  I've _always_ been able to come up with
> examples where it just doesn't work for me.  This doesn't mean VM
> overcommit should be abolished, because it's useful more often than not.

I hate to go completely offtopic here, but disks are so incredibly
slow when compared to RAM that there is really nothing the kernel
can do about this. Presumably the job will finish, given infinite
time.

How much swap do you have configured? You really shouldn't configure
so much unless you do want the kernel to actually use it all, right?
Because if we're not really conservative about OOM killing, then the
user who actually really did want to use all the swap they configured
gets angry when we kill their jobs without using it all.

Would an oom-kill-someone-now sysrq be of help, I wonder?
