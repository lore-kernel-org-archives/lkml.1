Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbXGWQKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbXGWQKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762643AbXGWQKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:10:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:58884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764110AbXGWQKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:10:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
Date: Mon, 23 Jul 2007 18:10:08 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231810.08445.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 18:05:38 Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [2/8] i386: bitops: Rectify bogus "Ir" constraints
> 
> The "I" constraint (on the i386 platform) is used to restrict constants to
> the 0..31 range, for use with instructions that must deal with bit numbers.

It means I or r, not I modified by r. This means either a immediate constant
0..31 or a register, which is correct.

% cat t18.c 

f()
{
        asm("xxx %0" :: "rI" (10));
        asm("yyy %0" :: "rI" (100));
}
% gcc -O2 -S t18.c
% cat t18.s
...
f:
.LFB2:
#APP
        xxx $10
#NO_APP
        movl    $100, %eax
#APP
        yyy %eax
#NO_APP
        ret
.LFE2:
...

-Andi

