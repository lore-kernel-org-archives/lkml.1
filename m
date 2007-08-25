Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbXHYRbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbXHYRbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 13:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXHYRbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 13:31:45 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:3589 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXHYRbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 13:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PZap1XGLmlU9GEMFdT99OYp+4u17M5ALG0OKa60Ain0rQOohAUcSPJUBvXfbnJQoSvdhk2DX1dHbrq+blwfeFYF5SCoS5SNbzW2LQj23d/QyaJzMa24yVZaQOx/pn0lq4Y/gRjJZoBZp9ri0m4qnORs0yIwOzWnlw34kIcIzMpU=
Message-ID: <e21d91280708251031k5e3bd962o6a268e6506696a8c@mail.gmail.com>
Date: Sat, 25 Aug 2007 13:31:43 -0400
From: "Clark Cooper" <clark.cooper@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Caught SIGFPE exceptions aren't reset
In-Reply-To: <e21d91280708251018l4904b6bcm5b40e22b6b2cbedc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e21d91280708242140i2e6223a4v51ba016837b74be8@mail.gmail.com>
	 <18128.322.59087.367556@alkaid.it.uu.se>
	 <e21d91280708251018l4904b6bcm5b40e22b6b2cbedc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your prompt answer. You wrote:


> Your handler can do this by masking
>  exceptions, changing the operands of the failed FP instruction,
> or by changing the PC so that the failed instruction is skipped
> (your handler may want to emulate the instruction in this case).

Given the current SIGFPE handling in the kernel, a userland handler
CAN'T mask the exceptions or clear the exception flags. This is
demonstrated in my example program where I call both feclearexception
and fedisableexception in the handler. The reason these don't work is
that any change you make to these FPU registers is overwritten with
the saved FPU context on return from the signal handler. Changing the
PC won't help since the exception flag is still set and unmasked on
signal return.

Now either the kernel should clear the corresponding exception flags
or it should present the correct FPU state to the handler for
manipulation. Currently neither of these appear to be the case. So if
there is no problem with the kernel, then the signal man pages should
indicate that while you can catch a SIGFPE, you can't actually return
from it.

If I am completely wrong on this, could you please indicate what kind
of change could be made to the handler in my example program to allow
it to reach the final printf statement in the main program?

Thank you,
Clark Cooper
