Return-Path: <linux-kernel-owner+w=401wt.eu-S937118AbYEUUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937118AbYEUUrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYEUUrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:47:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:37714 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYEUUrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:47:06 -0400
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-m32r@ml.linux-m32r.org,
       takata@linux-m32r.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Luke Browning <LukeBrowning@us.ibm.com>
In-Reply-To: <20080521190659.GB12638@uranus.ravnborg.org>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
	 <20080413171953.bde5e9ac.akpm@linux-foundation.org>
	 <1208133506.6958.82.camel@pasglop>
	 <20080413191338.9776ebd0.akpm@linux-foundation.org>
	 <1208491086.6958.381.camel@pasglop>
	 <20080417211905.8ff769fa.akpm@linux-foundation.org>
	 <1208501061.6958.394.camel@pasglop> <1211392585.8297.218.camel@pasglop>
	 <20080521114147.59ca3551.akpm@linux-foundation.org>
	 <20080521190659.GB12638@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 21 May 2008 16:38:20 -0400
Message-Id: <1211402300.8297.240.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-21 at 21:06 +0200, Sam Ravnborg wrote:
> It was discussed to add some run-time checks for this issue.
> But the examples given were a bit fluffy so I never integrated
> anything
> i kbuild to detect this.
> 
> As this is only a bug for const weak functions they could be made
> non-const
> if they are seldomly used?

With the asm("") trick ?

I suppose, but I'm also happy to just reject the bad gcc...

It shouldn't be too hard to do a test case made of 2 files.

test_foo.c

int foo(void)
{
	printf("good\n");
}

test_bar.c

int foo(void) __weak
{
}

int main(void)
{
	foo();
	return 0;
}

And check for "good" in the output of said program..

Can somebody test that ? Luke, you have a broken compiler, can you make
up some test that could be integrated in the kernel build system
easily ?

(I'm travelling right now, no time to play much with it myself).

Cheers,
Ben.


