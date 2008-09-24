Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYIXUuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYIXUuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbYIXUsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:48:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbYIXUsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:48:45 -0400
Date: Wed, 24 Sep 2008 16:48:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Miller <davem@davemloft.net>
cc: torvalds@linux-foundation.org, mbligh@google.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, prasad@linux.vnet.ibm.com,
       compudj@krystal.dyndns.org, fche@redhat.com, dwilder@us.ibm.com,
       hch@lst.de, zanussi@comcast.net, srostedt@redhat.com
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080924.133720.72895701.davem@davemloft.net>
Message-ID: <alpine.DEB.1.10.0809241647330.6759@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <20080924.133720.72895701.davem@davemloft.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, David Miller wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 24 Sep 2008 13:23:47 -0700 (PDT)
> 
> > So I'd like the thing to have small headers, and be designed from the 
> > start to have small headers.
> 
> Small headers are good, but I'd suggest making sure there is an
> "offset" or similar field in there.
> 
> Not that I want to encourage frequent changes to header layout, but if
> you do need to add something, then this offset field allows you to do
> so while keeping existing analysis tools working.  They will just
> ignore the new information in the headers, but they will still be able
> to get at the data bits using the offset.

Right now I have a "length" field when fixed_length is not specified. This 
length is currently offest by 8 leaving all 8 bytes aligned.

We could change this to be variable? Would that help you?

-- Steve

