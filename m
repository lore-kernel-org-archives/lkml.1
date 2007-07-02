Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbXGBOJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbXGBOJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759500AbXGBOJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:09:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:8088 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759479AbXGBOJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A4+FM1O+eNr0etJWmO0nrgJ+VmnRN2PKMFYLwR0CBvCaxQY8Oun3dWJRlqe7ZpdwN0h3tFQdjceOSb1AL6xFQ1BkNDNTPsub6ulpUpRv/fsVUTZ6w9knFOqyMdwCv1MWQDj4DRHybLtJroIucDwbgQxhidt7selQKPP2LgoUdVc=
Message-ID: <a36005b50707020709s87bde71m325a4ced02eb6e2b@mail.gmail.com>
Date: Mon, 2 Jul 2007 07:09:26 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0707011003510.7547@alien.or.mcafeemobile.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> With the current API design you'd able to easily confine the "pre" code
> inside the "set" function, and the "post" code inside the "unset"
> function. It looks pretty clean to me, and allows to limit the knowledge
> of sys_indirect, the more as possible inside kernel/indirect.c.

But this will not be applicable.  We already discussed that each
syscall likely needs its own set of flags etc.  There really isn't
much overlap if any which cannot be handled at least as well using a
flat structure.  You're adding major complications for something which
IMO will never be usable.  With the flat structure to whole overhead
of sys_indirect is limited to a test for valid syscalls, copying the
struct, making the call to the syscall function, and resetting the
value in current.  Very simple and fast.
