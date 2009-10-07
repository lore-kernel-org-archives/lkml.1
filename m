Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbZJGPid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbZJGPid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZJGPid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:38:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956AbZJGPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:38:32 -0400
Date: Wed, 7 Oct 2009 08:36:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] printk: clean up return value
In-Reply-To: <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk>
Message-ID: <alpine.LFD.2.01.0910070828190.3432@localhost.localdomain>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Alan Jenkins wrote:
> 
> We could fix this up, but it seems pointless.  Callers don't really care
> about the extra characters added by printk().  Instead, let's return the
> length of the original message as formatted (and possibly truncated)
> by vscnprintf().

Hmm. I kind of agree with this, but at the same time I suspect that no 
caller should ever care about the loglevel characters (since they won't be 
_shown_), so your change still doesn't make it return a sensible value.

So I get the feeling that you should also add a

	message_len -= 3;

to the case where we peel off the "<.>" loglevel part at the head of the 
string. No?

Or we could just change it to 'void'. As Joe Perches says, nobody really 
cares deeply enough for this to generally even matter.

		Linus
