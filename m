Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbXGYEy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbXGYEy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbXGYEyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:54:19 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:22357 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750794AbXGYEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:54:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=dElzPDSLdoKTMntsD9kXnwF5W2O5LH3cVxds0bD0jKf9j5sXf1eAR+UDGbZYMT7YHc3oq7TW8yBuctBt3y8geOvFAtX5FJbTuhynUYbYdgu+1eAhHZ/am+kvZb07RaBnO6yG13m5sBvQ+6bDGWVnphTKdTDWbPbFBwxLE3597qE=  ;
X-YMail-OSG: LEzDQgsVM1k6wxysZ2ox3jkgcqRMZFi.tfrs5A_8y5DyyLAuLJmKeqDMlf72ICqieF2zoUjkvQ--
Message-ID: <46A6D775.4030802@yahoo.com.au>
Date: Wed, 25 Jul 2007 14:54:13 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory addresses
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>  <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in>  <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org> <1185270544.5439.252.camel@localhost.localdomain> <alpine.LFD.0.999.0707241017440.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707241017440.3607@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 24 Jul 2007, Benjamin Herrenschmidt wrote:

>>Besides, as Nick pointed out, it prevents some valid optimizations.
> 
> 
> No it doesn't. Not the ones on the functions that just do an inline asm.
> 
> The only valid optimization it might break is for "constant_test_bit()", 
> which isn't even using inline asm.

The constant case is probably most used (at least for page flags), and
is most important for me. constant_test_bit may not be using inline asm,
but the volatile pointer target means that it reloads the value and can't
do much optimisation over it.

BTW. once volatile goes away, i386 really should start using the C
versions of __set_bit and __clear_bit as well IMO. (at least for the
constant bitnr case), so gcc can potentially optimise better.

-- 
SUSE Labs, Novell Inc.
