Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbZACTd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbZACTd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 14:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZACTdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 14:33:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:52486 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZACTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 14:33:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o10uyi6fREgWdOZ3VnIMXVMbkYI9iLJxzFLN1qzqPkaZLfhjQfJ/QfJw2ARZ5GVSgr
         C0xaaX0vXGiWuqYHiQYyjvzTDPF9qravZ4q/ci5mN7AF250oRTL6hm9nnjVxyHVF0jSk
         u5fHpSF7EkiPElqrqv2JaZNVA6l/j9gFci3d8=
Subject: Re: [PATCH] printk: Let %pR handle NULL pointers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901030905140.3179@localhost.localdomain>
References: <1230979341-23029-1-git-send-email-xyzzy@speakeasy.org>
	 <alpine.LFD.2.00.0901030905140.3179@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 11:33:43 -0800
Message-Id: <1231011223.5500.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-03 at 09:10 -0800, Linus Torvalds wrote:
> 
> On Sat, 3 Jan 2009, Trent Piepho wrote:
> >
> > Have %pR print "[NULL]" for the resource range when passed a NULL pointer.
> 
> Wouldn't it be much nicer to just do it for _all_ pointer types?
> 
> IOW, a patch more like the appended.
> 
> Also, I'm not 100% sure that "[NULL]" is the right thing to print. Not 
> that I know if there's anything better. Testing glibc, it prints "(nil)" 
> for a NULL string (%s) and "(null)" for a NULL pointer (%p). Which makes 
> no more sense than anything else, but maybe we could make the NULL %p case 
> at least match that if for no other reason than the fact that it would 
> match _something_.
> 
> Added the other people who added %pX modifiers to the cc - I guess the 
> networking people probably never have NULL pointers there anyway, but 
> maybe they have opinions.

I'm of two minds here, the only reason I didn't add NULL handling to %pI[46] and 
%pM is because they were previously printing values rather than pointers and
was guaranteed to never be null.  Also, with the current values, the output
is always a fixed-width for %pI6, %pM.  %pI4 can vary from 7-15 chars, but
[NULL] is only 6 chars (and obviously has a totally different format).
Of course it's hard to see how a caller could screw that up...but since I
didn't check everybody using it, I didn't risk it at the time.

On the other hand, I'm not sure if we want each %p formatting to have to deal
with its own null-formatting.

I'll do an audit of a handful of pI46, pM users currently, and try to find places were
a short string/completely different format string could cause problems...but
your patch is fine for today as all of the existing users [cs]houldn't be passing
in null anyways.

Harvey

