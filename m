Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbXGCA2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbXGCA2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbXGCA2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:28:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:3705 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbXGCA2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MiIFGDTPuMeY5Y/MO3mxPAC5Ts52R24spOjKTa3gLI4dgnHxOBFtFk0NWdGTE0kbe4Agv8WFiAV9HXm79DvZcR7ybg6eKGjgnpEyvInSY/7rv8775jZc98yAmNqr0GtXcOpGcP7DWnRr7qPygx8vnRVSnEkDHqoRgrnz8zlQ48k=
Message-ID: <a36005b50707021728q2b5cac73qde36ed063a82eb24@mail.gmail.com>
Date: Mon, 2 Jul 2007 17:28:08 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0707021119460.14774@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0>
	 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com>
	 <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com>
	 <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com>
	 <Pine.LNX.4.64.0706301458300.2957@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0706301529310.2957@alien.or.mcafeemobile.com>
	 <a36005b50707010925k5c936c1ch2238b560c595a833@mail.gmail.com>
	 <Pine.LNX.4.64.0707011003510.7547@alien.or.mcafeemobile.com>
	 <a36005b50707020709s87bde71m325a4ced02eb6e2b@mail.gmail.com>
	 <Pine.LNX.4.64.0707021119460.14774@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> Never be usable? I made you a concrete example that is like 8 months old.
> And *that* could not have been cleanly handled with the flat structure
> idea.

First of all, sigmasks are not widely needed.  Second, why on earth
shouldn't it be possible with a flat structure?  Just have the sigmask
in the same position.  It's no magic.


> But there are
> examples (and the signal stuff is one of them), where you do need the
> set_context+syscall+unset_context abstraction, for all cases where the
> kernel already has its own internal data strctures. In those cases you'd
> have to spread sys_internal context knowledge all around the kernel,
> whereas the current solution allows you to confine the code inside
> kernel/indirect.c

Nonsense.  Whether you have a new word in the task structure or a
pointer to a structure, you have to embed knowledge of this
indirection in every affected code paths.  There is no difference
here.  The only difference is that trying to force everything through
an artificially complicated common entry code.

I hope that Andrew+Linus will see through this.  I'm done arguing.
