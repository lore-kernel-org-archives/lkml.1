Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXIAUTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXIAUTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 16:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbXIAUTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 16:19:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:18753 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbXIAUTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 16:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=T7E+EhO+Mfg/1RKNObdidcmF5epYaO6KBhcz7LbCN+6MKRVhFA/5gdsqc41EVhe8+WsXzERvKIuopFoRVLDiQ7USkTffm+Xis4Pa6EZKShKSDqAPqQyujmQf6E4TO4PeeFRkAx1PYyt0DfnmNg1zPDXdXfebPJPpA52O28ibqeM=
Message-ID: <46D9C935.3000701@gmail.com>
Date: Sat, 01 Sep 2007 22:19:01 +0200
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>	<8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com>	<Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz>	<8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com>	<Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz> <20070830180538.b52b802d.akpm@linux-foundation.org>
In-Reply-To: <20070830180538.b52b802d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

Andrew Morton wrote:
> On Thu, 30 Aug 2007 17:10:03 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
>> Andrew, do you still strongly oppose to having ARCH_HAS_RANDOMIZE_BRK 
>> macro instead please?
>>
> 
> Not strongly, but the general opinion seems to be that ARCH_HAS_FOO is
> sucky.  It should at least be done in Kconfig rather than in .h, but even
> better is just to implement the thing for all architectures.
> 

Sorry for asking again but the initial poster haven't taken time to
answer to my feedbacks...

What about using a weak function in that case ? It actually gives a
default implementation in _one_ place and can be changed easily from
a nop to something more complex later.

Another point is that the current prototype of arch_randomize_brk()
could be slightly improved IMHO.

The proposed prototype is:

		    void arch_randomize_brk(void)

and I think it could be:

		  unsigned long randomize_brk(unsigned long brk)

Because the current code of exec syscall is rather.. hmm "tricky",
_hiding_ "current" global usage inside this function is error prone:
if this function is moved later, its use of "current->mm" could
reference the old mm process and it's hard to notice/fix.

thanks,
		Franck
