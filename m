Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYLCXdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYLCXdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYLCXdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:33:04 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:52131 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYLCXdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:33:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eo8/4XMUfP2mdeywzrJ1POQ5sIBmCRZIl0A7H8uH08agZ0KyqyFgQSyOUOh7ySDoE2
         +gJW44XfS5AQSuqOg0iwWNDHirYC6F+iNQ6sLOiguFlEymRMdquFCddlfSutd+SUkNEn
         Gtdb0nfmXhLxwfN/WV2isZDZ1a25Gfe9nUstk=
Message-ID: <c62985530812031533w1b90f423lcae013b96dfe8ba9@mail.gmail.com>
Date: Thu, 4 Dec 2008 00:33:00 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>
Subject: Re: [PATCH] tracing/function-branch-tracer: support for x86-64
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1228339777.2982.1288110715@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49347147.8070405@gmail.com>
	 <1228339777.2982.1288110715@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/3 Alexander van Heukelum <heukelum@fastmail.fm>:
> Hi Frederic,
>
> The changes to entry_64.S look simple enough. The order of
> saving the registers on the stack is not important in any
> way, right?
>[...]

No they don't matter.
All arguments should be saved on ftrace_graph_caller to not loose them
on call entry hooking.

On return (return_to_handler), I thought that I only needed to save
%rax (return value), the other scratch registers shouldn't matter at
the return state and the others will be saved by the return hooker.

But when I only save %rax, my system crashes. I don't know why so I
kept saving all scratch registers.

> I think this can be done with:
>
> _ASM_EXTABLE(1b,3b)
> _ASM_EXTABLE(2b,3b)
>
> (from: arch/x86/include/asm/asm.h)

Thanks. That and the generic move have actually been implemented by
Steven very recently:
http://lkml.org/lkml/2008/12/2/280
