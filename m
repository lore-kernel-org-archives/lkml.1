Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbXJYEUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbXJYEUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbXJYEUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:20:42 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:34844 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752011AbXJYEUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:20:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G9slMMyAsg3vedxz9OrM9JBBzLzO7QytaDK2MMDm7dJdI9G4Ke755Fg8FPGqK0XwYT5eHmjjCkF7UAGqauTuR7i+V64WpjbYS1fa6m9V4W7RwEvdEzvr+v0n/gOtLDf5A4G9G/jQxSdqIoPWgrOhTUAUgXpbdkUFqY0ogHpxOV8=  ;
X-YMail-OSG: o71nxdgVM1knk8lyY8oC28wwmTTPuIaORkaaT8tHw4aksY1oQOKoP4NxY.1_GXYjofEYXHF7XA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] Add lock_page_killable
Date: Thu, 25 Oct 2007 14:13:57 +1000
User-Agent: KMail/1.9.5
Cc: Matthew Wilcox <matthew@wil.cx>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
References: <11932286982175-git-send-email-matthew@wil.cx> <11932286982653-git-send-email-matthew@wil.cx> <20071024211140.329fdd90.akpm@linux-foundation.org>
In-Reply-To: <20071024211140.329fdd90.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251413.57677.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 14:11, Andrew Morton wrote:
> On Wed, 24 Oct 2007 08:24:57 -0400 Matthew Wilcox <matthew@wil.cx> wrote:
> > and associated infrastructure such as sync_page_killable and
> > fatal_signal_pending.  Use lock_page_killable in
> > do_generic_mapping_read() to allow us to kill `cat' of a file on an
> > NFS-mounted filesystem.
>
> whoa, big change.
>
> What exactly are the semantics here?  If the process has actually been
> killed (ie: we know that userspace won't be running again) then we break
> out of a lock_page() and allow the process to exit?  ie: it's basically
> invisible to userspace?

The actual conversions should also be relatively useful groundwork
if we ever want to make more things become generally interruptible.


> If so, it sounds OK.  I guess.  We're still screwed if the process is doing
> a synchronous write and lots of other scenarios.

I don't think it will matter in too many situations. If the process is
doing a synchronous write, nothing is guaranteed until the syscall
returns success...
