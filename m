Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZAVQVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZAVQVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZAVQVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:21:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:29845 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZAVQVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:21:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lLDv3cOp48pST5Kbu8oPYDgBAy9v4Q+bpwAXzu1GSIlFIGxgKEAw3JXapmAIxCfBVa
         NlLpZrT5m1YpeK5sXAe2kZHY1AMUIjbaxow/90ONP1dJQoYIWpl90vxDGs5lApHKzg7C
         ah0XnUQ2dQsVPfTz9WTJUs4enWShiFXwwX/H4=
Date: Fri, 23 Jan 2009 00:20:42 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Shane Hathaway <shane@hathawaymix.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: uml: sigprocmask fix
Message-ID: <20090122162042.GH9732@hack.private>
References: <49752649.3000508@hathawaymix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49752649.3000508@hathawaymix.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 06:18:01PM -0700, Shane Hathaway wrote:
>I just ran into the same issue described here:
>
>http://lkml.org/lkml/2009/1/15/194
>
>Like Americo Wang, my user mode linux compile failed when attempting to
>link ".tmp_vmlinux".  However, his patch is probably wrong.  The problem
>is that the name "sigprocmask" is getting renamed to
>"kernel_sigprocmask" by a compiler directive in arch/um/Makefile, then
>that name gets mangled into "sys_kernel_sigprocmask" by the
>SYSCALL_DEFINE3(sigprocmask, ...) macro in kernel/signal.c.


Hmmm, I found this, but note that replacing sigprocmask with
kernel_sigprocmask is done by strip, that should be after compiling.
But macros are processed before compiling.

Am I missing something?

Thanks.

-- 
"Against stupidity, the gods themselves, contend in vain."

