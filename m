Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYKWJnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYKWJnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYKWJnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:43:21 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:65022 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYKWJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=U/WVxrAqM5UxwWE4m0lGdeh3EFdyGJMIvcVd7qelzugEtx0rWGc9Ns3V5DivXrIgJ0
         aL9G0aRF+3rvu4dTT+t/B8v1zzuLhhhisf8+u+XMuQTV0Qd5MhkQif8cgfHMw6Fh3G2X
         RQ+JHOWgqYJ2ivQsUNCJAlcTtu6/kV3Z4lq6Q=
Message-ID: <492925B0.9030404@gmail.com>
Date: Sun, 23 Nov 2008 18:43:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: poll: allow f_op->poll to sleep, take #3
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com> <20081123085902.GI30453@elte.hu> <49291F06.5040907@gmail.com> <20081123093420.GN30453@elte.hu>
In-Reply-To: <20081123093420.GN30453@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> _sync() is not something that should normally be done from poll 
> handlers. But ->poll() handlers should all be TASK_INTERRUPTIBLE, 
> right? So wake_up_process_interruptible() should be the thing you 
> need?
> 
> Anyway, if you really want to pass in a state filter, you can use the 
> already existing wake_up_state() method as well.

It's not really about what I want but more about how the interface
looks in the first place.  Something like the following is simply
ugly.

int my_callback(param a, param b, param c)
{
	WARN_ON(b != B);
	do_something(a);
}

And @sync might be useful depending on who's waking it up, so we
either need to change the wake interface or give it an easier way to
pass those parameters as received.  The callback function isn't the
right place to ignore those parameters.  It simply doesn't know why
the caller is passing them in or what they mean under the
circumstances.

Thanks.

-- 
tejun
