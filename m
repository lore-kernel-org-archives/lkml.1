Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZD2Nnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZD2Nnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZD2NnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:43:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61710 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZD2NnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:43:21 -0400
Date: Wed, 29 Apr 2009 09:43:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurement
 for per worklet
In-Reply-To: <20090429133342.GA5987@nowhere>
Message-ID: <alpine.DEB.2.00.0904290942000.8066@gandalf.stny.rr.com>
References: <49F6DFB5.2040901@cn.fujitsu.com> <20090429000616.f7e72b73.akpm@linux-foundation.org> <20090429133342.GA5987@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Apr 2009, Frederic Weisbecker wrote:

> On Wed, Apr 29, 2009 at 12:06:16AM -0700, Andrew Morton wrote:
> > What is the meaning of M_EXECus?  Mean execution time in microseconds,
> > I assume?  I wonder if that is sufficiently high resolution nowadays.
> 
> 
> It's the maximum execution time encountered for a given worklet.
> I also have a small patch, about ready, to get the average.
> 
>  
> > You'll note that all the functions are reported as "foo+0x0/0xN". 
> > There is a way of suppressing the unneeded and unuseful "+0x0/0xN",
> > but I forget what it is and the comments over lib/vsprintf.c:pointer()
> > didn't help.  I think it's %pS.
> 
> 
> I don't know any way to perform this.
> %pF and %pS will act pretty much the same, except:
> 
> Extract from lib/vsprintf.c:
> 
>  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>  * function pointers are really function descriptors, which contain a
>  * pointer to the real address.
> 
> But the output formatting is the same: address, offset, size, modname.

I could not find any way to remove it, thus I wrote my own version of %pF 
to get rid of the +0x0/0xN notations in the output for ftrace.

-- Steve
