Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXGIE7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXGIE7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXGIE6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:58:55 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:22918 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751291AbXGIE6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:58:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=VB71BRQnRLcWUyf4cS0tQVnH2htDBN3J2wpezvHqUPgUmhppGLRPlOEhuRuOcyrjdsrPXKsuEzew2dLzro0GCpNGCjSno/mqRUmtOUivMsl+EXXlFM6bqiyKXjURVBJ/qZVQtghQm8vZF2gzcQV3Upyb1+nYavS/uzhFSh3dSoA=  ;
X-YMail-OSG: j_9bIw8VM1lN7SM6hmXtk27lpRAJwanGdqhXvQJxTZWjfw9KYT7ZnvawfAmUvC9YegetatC1lw--
Message-ID: <4691C08A.90707@yahoo.com.au>
Date: Mon, 09 Jul 2007 14:58:50 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx>	<4691B9A5.6060203@yahoo.com.au> <87k5taw5vc.fsf@jbms.ath.cx>	<4691BD6F.8000809@yahoo.com.au> <87fy3yw50p.fsf@jbms.ath.cx>
In-Reply-To: <87fy3yw50p.fsf@jbms.ath.cx>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:

>>Yes, I have a rough idea about how page reclaim works. But I just
>>mean it would not be trivial to load the new kernel into physically
>>discontiguous memory. Possible of course, but I don't think kexec or
>>the setup code could quite cope ATM.
> 
> 
> It would indeed be a pain for the new kernel to be loaded and have to
> use discontiguous memory.  The trick is, though, that this is not
> necessary.  Immediately before jumping to the new kernel, the first X
> bytes (where X is the amount of memory the new kernel will get,
> typically 16MB or 64MB) of physical memory are backed up into the
> arbitrary discontiguous pages that are made available.  This will not
> take very long, because copying even 64MB of memory is extremely fast.
> Then the new kernel is free to use the first X bytes of contiguous
> physical memory.  Problem solved.

Ah, that sounds like it would be the right way to go. Good thinking.

-- 
SUSE Labs, Novell Inc.
