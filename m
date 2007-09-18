Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbXIRGTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbXIRGTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbXIRGS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:18:56 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:52432 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbXIRGSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:18:55 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.22.6] nfsd: fh_verify() `malloc failure' with lots of free memory leads to NFS hang
References: <874phtkk25.fsf@hades.wkstn.nix>
	<20070917223600.GA30350@fieldses.org> <87zlzkkfvk.fsf@hades.wkstn.nix>
	<20070918011257.GC2443@fieldses.org>
From: Nix <nix@esperi.org.uk>
Emacs: or perhaps you'd prefer Russian Roulette, after all?
Date: Tue, 18 Sep 2007 07:18:47 +0100
In-Reply-To: <20070918011257.GC2443@fieldses.org> (J. Bruce Fields's message of "Mon, 17 Sep 2007 21:12:57 -0400")
Message-ID: <87tzpsh4xk.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 102; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Sep 2007, J. Bruce Fields stated:

> On Tue, Sep 18, 2007 at 12:54:07AM +0100, Nix wrote:
>> The code which calls new_do_write() looks like this:
>> 
>> ,----[ libio/fileops.c:_IO_new_file_xsputn() ]
>> |  if (do_write)
>> |    {
>> |      count = new_do_write (f, s, do_write);
>> |      to_do -= count;
>> |      if (count < do_write)
>> |        return n - to_do;
>> |    }
>> `----
>> 
>> This code handles partial writes followed by errors by returning a
>> suitable nonzero value, and immediate errors by returning -1.
>> 
>> In either case the buffer will have been filled as much as possible by
>> that point, and will still be filled when (vf)printf() is next called.
>
> OK, I'm a little lost at this point (what's n?  What's to_do?), but I'll
> take your word for it.

n is the total amount to write: to_do is the amount still unwritten. The
rest is buffered but written.

> I'd be kinda curious when exactly the behavior changed and why.

Same here. I'm sort of surprised that it *did* change. The last change
to anything in that function was in 2005, and the fragment shown is
ten years old.

I suspect some other change made it easier to see this pre-existing
behaviour. I wonder if something in glibc used to call __fpurge() for
you?

> Also I suppose we should check which version of nfs-utils that fix is in
> and make sure distributions are getting the fixed nfs-utils before they
> get the new libc, or we're going to see this bug a lot....

And since it looks like a kernel bug idiots like me are going to keep on
bugging the l-k list with a non-kernel bug.

> Let me know if the problem's fixed.

Well, the machine's still running after more than six hours, where before
it would freeze solid in half an hour or less.

So I'd say it's fixed :)

-- 
`Some people don't think performance issues are "real bugs", and I think 
such people shouldn't be allowed to program.' --- Linus Torvalds
