Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZILSUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZILSUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 14:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZILSUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 14:20:03 -0400
Received: from fifo99.com ([67.223.236.141]:59324 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbZILSUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 14:20:02 -0400
Subject: Re: [PATCH] x86: apic: convert BUG() to BUG_ON()
From: Daniel Walker <dwalker@fifo99.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090912180527.GA4893@lenovo>
References: <1252777220-30796-1-git-send-email-dwalker@fifo99.com>
	 <20090912180527.GA4893@lenovo>
Content-Type: text/plain
Date: Sat, 12 Sep 2009 11:20:41 -0700
Message-Id: <1252779641.28368.81.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 22:05 +0400, Cyrill Gorcunov wrote:

> 
> Hi Daniel,
> 
> I believe having a changelog like
> 
> 	Use short form of "if() BUG()" sequence
> 
> would be better perhaps? Since "Coccinelle's BUG_ON semantic patch"
> somehow doesn't describe why it's done.
> 
> Don't get me wrong please. It's trivial and seen from patch
> itself _why_ it's done though changelog doesn't say the same.
> 
> Perhaps I'm too nagging :) Feel free to ignore me.

Not nagging, I wondered myself what the benefit was when I ran
Coccinelle.

For one it condenses duplicate code (i.e. the if()). If the BUG_ON()
macro gets updated with something new, all the users get the updates
automatically. The other thing is your re-using potentially more
advanced code that's inside the macro. In this case it's fairly trivial,

#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)

So we're getting the benefit on the new "unlikely" in the apic code.
unlikely/likely calls will usually allow the compiler to create smaller,
and or, more optimized code. 

So there are at least two benefits, and I don't see any downside to it.

Daniel

