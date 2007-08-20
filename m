Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbXHTA6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbXHTA6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXHTA6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:58:00 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:31026 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753616AbXHTA57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:57:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RGqFALTwXiNz3+TAiK26Ueq+o2zgRh8efmfgCic95fHZeruTQXVwFjxhthMnYoPRN8ehZVI3pWTdebpdGzWtjF3eZF/YFvcE/9beLITZmD7TQhoifF4t/r7uynGMCL0TpU6QBpbRnd4M//lSaZnHnJbOQSo5v/5XAiQKozvUhrM=  ;
X-YMail-OSG: df4iGYMVM1lbDM9B31uJrvqrxigSPpkuk79pthqu77IlilTVO4Wqy7.sXerM09pxhRccMC7nvL5YTzWUyCmGIuGqslJvAIevS39wm_7TYEEk4FA_rmLd8vnYgiHy6F6jT_pgb6psptJsnlw-
From: David Brownell <david-b@pacbell.net>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Date: Sun, 19 Aug 2007 17:57:56 -0700
User-Agent: KMail/1.9.6
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070819225546.GV21089@ftp.linux.org.uk> <200708191719.48340.david-b@pacbell.net> <E83C36D0-B72E-4E70-BEF6-4AF54BAD2863@cam.ac.uk>
In-Reply-To: <E83C36D0-B72E-4E70-BEF6-4AF54BAD2863@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708191757.56520.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Anton Altaparmakov wrote:
> >
> > ISTR we don't *have* a uintptr_t on all architectures, or that would
> > be the appropriate thing to use in these 32/64 bit ABI scenarios.
> >
> >
> >> Use unsigned long or uintptr_t instead.
> >
> > I suspect you mean "unsigned long long"...
> 
> No he doesn't.  "unsigned long" is guaranteed to be large enough to  
> hold a pointer (at least on Linux anyway).

And yet when I used that, I got compiler warnings on some systems.

ISTR that was the first solution I tried, but GCC really wanted to
issue warnings.  Either about casting 64-bit to pointer, or about
casting it to "unsigned long", either way lost precision.


> On a 32-bit arch "unsigned long" is 32-bit and pointers are 32-bit.
> 
> On a 64-bit archi "unsigned long" is 64-bit and pointers are 64-bit.

So with 32 bit userspace "unsigned long long" is the type to use
when talking to a 64-bit kernel; and with pure 64-bit code, it's
enough to write "unsigned long".

I'm fairly sure that's the root cause of the pain I recall here;
but I'd have to run experiments again to verify that.  


