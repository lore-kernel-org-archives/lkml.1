Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYIXUhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYIXUhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIXUhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:37:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44590
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbYIXUhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:37:34 -0400
Date: Wed, 24 Sep 2008 13:37:20 -0700 (PDT)
Message-Id: <20080924.133720.72895701.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rostedt@goodmis.org, mbligh@google.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, prasad@linux.vnet.ibm.com,
       compudj@krystal.dyndns.org, fche@redhat.com, dwilder@us.ibm.com,
       hch@lst.de, zanussi@comcast.net, srostedt@redhat.com
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
	<alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
	<alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Sep 2008 13:23:47 -0700 (PDT)

> So I'd like the thing to have small headers, and be designed from the 
> start to have small headers.

Small headers are good, but I'd suggest making sure there is an
"offset" or similar field in there.

Not that I want to encourage frequent changes to header layout, but if
you do need to add something, then this offset field allows you to do
so while keeping existing analysis tools working.  They will just
ignore the new information in the headers, but they will still be able
to get at the data bits using the offset.
