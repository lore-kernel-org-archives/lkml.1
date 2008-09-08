Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYIHOp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYIHOp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYIHOpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:45:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:17877 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYIHOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=upFaCdSBDWDQ38mlOJKlguT6e0Uy9cNj6qSitSWDokjXl0HecpFc+Snc0xKOo8o6Gc
         3JVQMRPYoB8OMW0SnSb13XVBSQJnQA6qhfrN0nUw59LHPPAlHZ9C18hidOOxpxpYUqqO
         3PRxwA16Fs36xDzf1JFReHJA6rXQN/FJtUFSA=
Date: Mon, 8 Sep 2008 18:42:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] x86: io-apic - convert DO_ACTION macro into function
Message-ID: <20080908144242.GA7278@lenovo>
References: <20080907192625.GC7515@lenovo> <20080908143335.GD10580@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908143335.GD10580@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Sep 08, 2008 at 04:33:35PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Convert DO_ACTION macro into more obvious io_apic_modify_irq
| > function with callers
| > ---
| > 
| >  I found it more readable then original was. Especialy we could grep 
| > the callers in normal way. It's just an attempt - free to drop this 
| > patch. I hope I don't messed with all these masks :) So the question 
| > is rather NOT about details but idea in general.
| 
| yeah - getting rid of such macros is a very good idea in general.
| 
| >  io_apic.c |  102 ++++++++++++++++++++++++++++++--------------------------------
| >  1 file changed, 50 insertions(+), 52 deletions(-)
| 
| that's non-trivial impact. Did the .o md5sum survive this transformation 
| just fine? (in theory gcc should generate the same code - but it doesnt 
| always do that across macro->inline function changes, so it's hard to 
| validate these kinds of changes.)
| 
| 	Ingo
| 

ok, then I continue to work on this. I think I better check assembly code
to remain the same (in general since for example new for(;;) form is
completely different - in old code is inspired by the macroses who
could change 'entry' variable in theory - but now it will not be possible
and not needed so we could use more 'eye-candy' for(;;) form). Thanks
for comments.

		- Cyrill -
