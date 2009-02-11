Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbZBKS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbZBKS1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbZBKS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:27:34 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:3208 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbZBKS1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:27:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hAbuGROyMCwCmXdLFB801G7kbbmkEOAq9FJlK1SGcS3saYwO0LQtCw/M0xNK0Dxd1D
         bQREi06vEUm59LH9W7i7O2YuEgXHIbEnUYtjQ+9SmqtAqKJ4mxaUB7+xXazTXjnxO7k+
         dTsjVjCV3OJMqe0fU5fH+acxMX8S6tQFEIr7k=
MIME-Version: 1.0
In-Reply-To: <49931067.4090802@kernel.org>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>
	 <49931067.4090802@kernel.org>
Date: Wed, 11 Feb 2009 13:27:31 -0500
Message-ID: <73c1f2160902111027s2509f31fq732907bde8db775e@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need 
	it
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 12:52 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> Brian Gerst wrote:
>>  /*
>> + * For syscalls that need a pointer to the pt_regs struct (ie. fork).
>> + * The regs pointer is passed in %eax as the first argument.  The
>> + * remaining function arguments remain on the stack.
>> + */
>> +#define ptregscall __attribute__((regparm(1)))
>
> I was looking a few weeks ago (still a work in progress, but I'm pretty
> close to having something working) at getting rid of asmlinkage and try
> to get everything onto regparm(3).  Adding yet another calling
> convention seems to be a step in the wrong direction -- especially since
> regparm(1) and (2) are unlikely to have been well exercised and
> therefore are likely to attract gcc bugs.
>
> That does *not* mean in any way that I disapprove of the concept of
> accessing pt_regs via a pointer... quite on the contrary, I think it's
> the only sane thing to do.  I would like to see it done without adding
> calling conventions, and preferrably killing some off.
>
>        -hpa
>
>

I guess I could go back to extracting the args from the pt_regs struct
given just the pointer.  How do you intend to handle system calls in
your changes (normal ones, not needing pt_regs)?

--
Brian Gerst
