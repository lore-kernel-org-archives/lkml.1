Return-Path: <linux-kernel-owner+w=401wt.eu-S1763749AbXJOJ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763749AbXJOJ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbXJOJ6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:58:32 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:35767 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757717AbXJOJ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:58:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZC2STlxgGAMf1ppt2ZW3p0lbmwH9YWfq/uyZk0kg4eq698T2I8Q7mcULYbjZQZkCK3YznLd03+SECQYeT+TAk8sK5otU9Fj6iASXxZJ0li8DWLOwNx1KvasWhey9puKnyeuxpPAPamq6/d8atw3k0yEL1txIdzSwL1XJfi5Xvas=  ;
X-YMail-OSG: 6aTSMkcVM1kqMeMUsYOsjlGj7RVzycCJL3OvLjQz.ERES6EheQLSsQ1vEw0dY.bM3oex2LjnVg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rob Landley <rob@landley.net>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Tue, 16 Oct 2007 01:08:37 +1000
User-Agent: KMail/1.9.5
Cc: Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
References: <200710112011.22000.rob@landley.net> <200710152337.45252.nickpiggin@yahoo.com.au> <200710150452.30939.rob@landley.net>
In-Reply-To: <200710150452.30939.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710160108.38222.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 19:52, Rob Landley wrote:
> On Monday 15 October 2007 8:37:44 am Nick Piggin wrote:
> > > Virtual memory isn't perfect.  I've _always_ been able to come up with
> > > examples where it just doesn't work for me.  This doesn't mean VM
> > > overcommit should be abolished, because it's useful more often than
> > > not.
> >
> > I hate to go completely offtopic here, but disks are so incredibly
> > slow when compared to RAM that there is really nothing the kernel
> > can do about this.
>
> I know.
>
> > Presumably the job will finish, given infinite
> > time.
>
> I gave it about half an hour, then it locked solid and stopped writing to
> the disk at all.  (I gave it another 5 minutes at that point, then held
> down the power button.)

Maybe it was a bug then. Hard to say without backtraces ;)


> > You really shouldn't configure
> > so much unless you do want the kernel to actually use it all, right?
>
> Two words: "Software suspend".  I've actually been thinking of increasing
> it on the next install...

Kernel doesn't know that you want to use it for suspend but not
regular swapping, unfortunately.


> > Because if we're not really conservative about OOM killing, then the
> > user who actually really did want to use all the swap they configured
> > gets angry when we kill their jobs without using it all.
>
> I tend to lower "swappiness" and when that happens all sorts of stuff goes
> weird.  Software suspend used to say says it can't free enough memory if I
> put swappiness at 0 (dunno if it still does).  This time the OOM killer
> never triggered before hard deadlock.  (I think I had it around 20 or 40 or
> some such.)
>
> > Would an oom-kill-someone-now sysrq be of help, I wonder?
>
> *shrug* It might.  I was a letting it run hoping it would complete itself
> when it locked solid.  (The keyboard LEDs weren't flashing, so I don't
> _think_ it paniced.  I was in X so I wouldn't have seen a message...)

If you can work out where things are spinning/sleeping when that happens,
along with sysrq+M data, then it could make for a useful bug report. Not
entirely helpful, but if it is a reproducible problem for you, then you
might be able to get that data from outside X.
