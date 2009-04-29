Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZD2NeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZD2NeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZD2Ndt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:33:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37560 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZD2Nds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ainLZqX7P7NkBZkuftgyW3usvwCUqtEz96yZZZNl0cpnUyLQB7u8ZVMR5P3+AVK+4l
         0AYMQPseUbZT8P5Q40LA7uInOkA0BgCNkEQrYq3GIoYDyNKUvYo17J09R/r8qonFouKN
         B2G12p9s97jHxgATMgtc1gN0hAbaU9Du0iQbQ=
Date: Wed, 29 Apr 2009 15:33:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurement
	for per worklet
Message-ID: <20090429133342.GA5987@nowhere>
References: <49F6DFB5.2040901@cn.fujitsu.com> <20090429000616.f7e72b73.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429000616.f7e72b73.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 12:06:16AM -0700, Andrew Morton wrote:
> What is the meaning of M_EXECus?  Mean execution time in microseconds,
> I assume?  I wonder if that is sufficiently high resolution nowadays.


It's the maximum execution time encountered for a given worklet.
I also have a small patch, about ready, to get the average.

 
> You'll note that all the functions are reported as "foo+0x0/0xN". 
> There is a way of suppressing the unneeded and unuseful "+0x0/0xN",
> but I forget what it is and the comments over lib/vsprintf.c:pointer()
> didn't help.  I think it's %pS.


I don't know any way to perform this.
%pF and %pS will act pretty much the same, except:

Extract from lib/vsprintf.c:

 * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
 * function pointers are really function descriptors, which contain a
 * pointer to the real address.

But the output formatting is the same: address, offset, size, modname.

I found it a bit annoying, so I proposed the following patch recently:

http://lkml.org/lkml/2009/4/15/310

And someone came with a better idea, IMO:

http://lkml.org/lkml/2009/4/17/105


> 
> The patchset adds no user documentation for the feature and should not
> (IMO) be merged in such a state.  Please.
>


Ok, I will try something today about the documentation.

Thanks!

