Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZBSTAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZBSTAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbZBSTAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:00:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:2224 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbZBSTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:00:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DDxNsqhpvPCqiTdXfJZMZS0yfJrS4A+Bhi0jD1zKXPtmq570LP4f1YXEcTqBw0oaIY
         duSXA8SCGwYX/JkOCWfzIwTwy2lw5bcA6MUUUjIK8XQtw7gvPy5aqxH0rlPDK7SdHqde
         JmZsW284yJ4V2SyUFIE3vi0Zv1+T2ykZAC2nQ=
Date: Thu, 19 Feb 2009 22:06:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
Subject: Banning checkpoint (was: Re: What can OpenVZ do?)
Message-ID: <20090219190637.GA4846@x200.localdomain>
References: <20090213105302.GC4608@elte.hu> <1234817490.30155.287.camel@nimitz> <20090217222319.GA10546@elte.hu> <1234909849.4816.9.camel@nimitz> <20090218003217.GB25856@elte.hu> <1234917639.4816.12.camel@nimitz> <20090218051123.GA9367@x200.localdomain> <20090218181644.GD19995@elte.hu> <1234992447.26788.12.camel@nimitz> <20090218231545.GA17524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218231545.GA17524@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that all these efforts to abort checkpoint "intelligently" by
banning it early are completely misguided.

"Checkpointable" property isn't one-way ticket like "tainted" flag,
so doing it like tainted var isn't right, atomic or not, SMP-safe or
not.

With filesystems, one has ->f_op field to compare against banned
filesystems, one more flag isn't necessary.

Inotify isn't supported yet? You do

	if (!list_empty(&inode->inotify_watches))
		return -E;

without hooking into inotify syscalls.

ptrace(2) isn't supported -- look at struct task_struct::ptraced and
friends.

And so on.

System call (or whatever) does something with some piece of kernel
internals. We look at this "something" when walking data structures and
abort if it's scary enough.

Please, show at least one counter-example.
