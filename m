Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZBXIsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZBXIsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 03:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZBXIsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 03:48:30 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:23808 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752338AbZBXIs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:48:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5zdJTp7ropKQqWU5Bs+RWyRDCh20UjELDfwVZkbiT4HmJ99wx1TCR9GYCYBW8fZfztapwZamQ42lYu6oIn+s3VOU/9KpAu3N0s3n76eIUu2YJFU1XeAQY6PjSE9YNfyWqz7JRWyA0IAQR9dDg/bM4tVSJ4X3IIxk75qBvE5wxt0=  ;
X-YMail-OSG: bptsne8VM1nP1YxqGN0O22hyo2f_3OAO0Ch4Z3dHHP8Lr_FoAqzJ6XT9L9DSKdVgUZcDNTL24MBwk.lYpQyYzCkIhIu7sMEZ1TONWJCZ1l.Xg2hJBua.Gg3IgyLxM1FxRcZTXc0v1VlFOnr5_LBAWTzEpxcsd8SWsAGWwy_1dMmZ1P.4OP7Pv4NbeDqf4.xcWjE.rmdJAvWOnXfGwXBbUeAIduBfdQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Another Performance Regression in write() syscall
Date: Tue, 24 Feb 2009 19:47:52 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090224060558.GA14812@google.com> <1235456745.26788.237.camel@nimitz>
In-Reply-To: <1235456745.26788.237.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241947.53180.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 17:25:45 Dave Hansen wrote:
> On Mon, 2009-02-23 at 22:05 -0800, Salman Qazi wrote:
> > Analysis of profile data has led us to believe that the commit
> > 3d733633a633065729c9e4e254b2e5442c00ef7e has caused a performance
> > regression.  This commit provides for tracking of writers so that read
> > only bind mounts function correctly.
> >
> > We can verify this regression by applying the following patch to
> > partially disable the above-mentioned commit and then running the fstime
> > component of Unixbench.  The settings used were 256 byte writes with
> > MAX_BLOCK of 2000.
>
> I'm a bit surprised that write() is what is regressing.  Unless I
> screwed up, we do all the expensive accounting at open()/close() time.
> Is this a test that gets run in parallel on multiple cpus?

Don't forget touch_atime...

Still, open/close isn't unimportant either.


> Could you take a look at Nick's patches to speed this stuff up?
>
> 	http://thread.gmane.org/gmane.linux.file-systems/28186
>
> We may need to dust those off, although I'm still a bit worried about
> the complexities of open-coding all the barriers.

I really need to do something about trying to push them upstream again
actually because we've got them in SLES11 tree.

It would be interesting to know how much the unixbench numbers improve
with the patches.

> Could we also see some kind of profile?  What kind of machine are you
> seeing this on, btw?


