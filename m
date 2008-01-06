Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYAFSn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYAFSn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYAFSnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:43:17 -0500
Received: from 1wt.eu ([62.212.114.60]:1190 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbYAFSnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:43:16 -0500
Date: Sun, 6 Jan 2008 19:34:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106183402.GA7906@1wt.eu>
References: <1199304735.3258.53.camel@localhost.localdomain> <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain> <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199640983.5205.65.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 11:36:23AM -0600, James Bottomley wrote:
> On Sun, 2008-01-06 at 10:11 -0700, Matthew Wilcox wrote:
> > If there's willingness to change, I'm willing to put some effort into
> > moving us to a bug tracking system that fits our workflow better than
> > bugzilla.  But if that effort will be disregarded, then let me know now
> > so I don't waste my time.
> 
> Well, I'd say yes, certainly, and I'll support the effort ... but the
> problem is that I'm not one of the powers that be who control our
> current bugzilla ... that's the constituency we need to convince.  As I
> keep saying, just getting new SCSI bug reports tipped onto the SCSI
> mailing list will give us about 90% of what we need, but I haven't even
> managed to get that to happen.

As long as the process will be that much complicated, it will never
correctly work. The primary requirement for a useful bug reporting
workflow is *not to put the burden on the reporter*.

I agree with Ingo here. How can a user know where to post ? He has
a problem with his Linux distro. He finally understands or gets told
that the strange numbers on the screen indicate a kernel oops and
that he must report it if he wants it to be fixed. He then googles
for how/where to report a bug, and the first reply says :

   http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html

in which you can read :

  "If you are totally stumped as to whom to send the report, send
   it to linux-kernel@vger.kernel.org".

So *this* is the official central entry point, like it or not. And
in fact it works, given the number of off-topic reports we get. It
proves that end users know how to report their problems there.

Other lists should be used when the problem is clearly qualified.
And most of the time, it's not up to the end user to qualify his
problem, but to *us*. Our mission is not to blindly write lines of
code, but to spend some time getting user feedback, and bug reports
are part of this feedback.

In my opinion, the most important reader contribution to LKML is
just reading bugs reports and redirecting them to the proper list
if obviously required. People do this all the time and it has
always worked.

In parallel, bug entries may be added into bugzilla, either by the
reporter once suggested to do so, or by the person redirecting him
to the proper list.

So a working workflow would look like this :

  1) from: user
     to: lkml
     subject: help needed with my CD burner

  2) from: any LKML reader
     to: user
     cc: lkml, linux-scsi
     subject: re: help needed with my CD burner
     
     Message forwarded to linux-scsi. You may accelerate resolution
     by describing your problem in bugzilla [url, mail...]

  => user knows his problem is being considered (very important)
  => user is connected with the proper list and possibly with a
     bugzilla entry. As long as the bug is not 100% sure relevant
     to linux-scsi, lkml should remain CCed so that other readers
     may occasionally spot the problem.

I would also like to make a parallel with how support works in
commercial products. Generally, you as the end user don't know
anything about the vendor's internal process. You don't even
know if you have an account on your vendor's support site (another
blocking factor of bugzilla BTW). So what you do is call any of
your contacts overthere, quickly describe your problem, and most
of the time he gives you all the indications required to report
a fine bug. And if he understands it will be too hard for you
(classically because of missing account), he will initiate it
by himself. At this point the bug is tracked and followed by the
appropriate persons.

LKML *is* the contact for any Linux Kernel problem or question.
As long as we will try to bypass it and create parallel ways,
it will only maintain confusion and lead to bugs getting dropped
with user frustration.

IMHO, the only missing indication in "reporting-bugs.html" above
is :

   "if you don't get any reply within 2 days, surely your mail
    has not been noticed, repost it, if possible with a more
    appropriate subject".

We will *never* be able to educate newcomers, but we can (and must)
educate regular readers to help newcomers report bugs. If only 100
regular readers randomly forward 2 mails a month, those are 200 bugs
which get properly handled. Just don't forget to change your reply-to
to lkml if you don't want to get polluted by the discussion.

As to using bugzilla for bug tracking... Well, I agree that bug
tracking is important when you work on multiple problems at once.
But bugzilla should be the developer's tool, not the end user's.
That means that it should only be our job to create entries there
if end users find it too difficult, and that we should just invite
them to *try* to report there to save us some time.

Willy

