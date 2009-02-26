Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZBZMsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZBZMsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZBZMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:48:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35961 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZBZMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:48:25 -0500
Date: Thu, 26 Feb 2009 07:48:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/5] [RFC] copy_strtok_from_user
In-Reply-To: <alpine.DEB.2.00.0902260742460.26792@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0902260747380.26792@gandalf.stny.rr.com>
References: <20090226053240.607719846@goodmis.org> <1235642612.4645.4737.camel@laptop> <20090226122859.GD23099@elte.hu> <20090226123017.GA2041@elte.hu> <alpine.DEB.2.00.0902260742460.26792@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Feb 2009, Steven Rostedt wrote:
> 
> not really. strsep stops at the first delimiter. strtok skips multiple 

I may have read the man page wrong. It does stop at the token not the 
delimiter.

Never mind :-p

-- Steve

> delimiters. I could implement the copy_strtok_from_user with a 
> copy_from_user (all of read), and then use strtok_r (reentrant version) to 
> find the next token. This would require implementing strtok_r for the 
> kernel.
> 
> Having the copy_strtok_from_user will handle the copying and the caller 
> would not need to worry about having a big enough buffer to hold 
> delimiters and tokens. The copy_strtok_from_user would copy first to an 
> internal buffer, then scan for tokens to copy into the callers buffer. 
> Then repeat until read or copy limits have been hit.
> 
> -- Steve
> 
> 
