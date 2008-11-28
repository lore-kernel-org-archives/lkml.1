Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYK1EoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYK1EoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYK1EoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:44:13 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:32408 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYK1EoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pAwuGwK2zm2S5tb+TMdcCmUAJPmLoKdGUalJ5CmkzKTG0GnQZUGUtQ14Jqz/O2DqWf
         lcgeEUW2fae8FJ6Cgbx1hJgz2UOy+sksD/FeR5Q0z+e+HOEDx3gePOJv69yef6h/flun
         Uup6xwBD+GH3qvUvhJCuMDz0GRSyfGWrhe9sM=
Message-ID: <492F7715.5030005@gmail.com>
Date: Fri, 28 Nov 2008 13:44:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Oleg Nesterov <oleg@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] poll: allow f_op->poll to sleep, take#6
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com> <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com> <492CEF04.6070100@gmail.com> <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com> <492E65F9.30208@gmail.com> <492E6A6E.9020000@gmail.com> <alpine.DEB.1.10.0811272033440.3147@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0811272033440.3147@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> Looks OK to me, although it'd be better if some more folks eye it, in 
> order to avoid painful mistakes.
> Did you test it al all in a live system?

Depends on what you call a live system.  I tested the functionalities
and they worked okay but considering the failure scenarios, it's
highly unlikely to happen especially on x86 cpus with all its nice
memory ordering rules.  Now that it has smp_wmb() on the wake up side
and full mb on waking up side, it's as conservative as it gets, so I
think we're in the safe.

Thanks.

-- 
tejun
