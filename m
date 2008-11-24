Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYKXRfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYKXRfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYKXRe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:34:58 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:33563 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbYKXRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EKwawgvnkAQ9gouyuODUayjzwd+ezBlAj0/BiYWjtLgvWYVrz+Imd5ia/Yi10Khpbh
         HSMb3HfxNQMwZdCWU09RtEET8X9rzy60pe+UDo7bxNhDdggsrhq9AGiH2n2rVldHGsIW
         4fdRoN9wQLDFZDMJGkK2uqhhfy54qWC5C1sYY=
Message-ID: <c62985530811240934i659c571p5272570e5ea03c13@mail.gmail.com>
Date: Mon, 24 Nov 2008 18:34:56 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: Human readable output for function return tracer
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811241202060.20122@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
	 <alpine.DEB.1.10.0811241202060.20122@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Steven Rostedt <rostedt@goodmis.org>:
> A little off topic, but how do you handle collapsed returns?
>
>  func1() {
>        [...]
>        func2();
>        return;
>  }
>
> Instead of using call *func2, gcc may decide to collapse it. That is,
> since it is the last thing done on func1, it may pop func1's frame all the
> way to func1's return address, and then do a "jmp" to func2. func2 will
> still call mcount, but on its return, it will jump to the func1 return
> address.
>
> Perhaps this is OK. The call to func1's mcount will store the original
> return address and replace it with the function return code. The call to
> func2 will store that return address and replace it with the func2
> function return code. And both of them will still be processed.
>
> OK, I think I answered my own question, but I'm keeping it in this post
> just to make sure I understand it correctly.


Yes, perhaps it is done that way. Or perhaps CONFIG_FRAME_POINTER avoids
such collapsing calls... I don't know.
Perhaps I should look at some disassembly dumps to ensure things are safe, but
I didn't have any problem with that...


> Do you have a record that you store when you make the first mcount call.
> In this record, could you save the depth of the parent there too. I do not
> remember the code exactly, so I might be off here ;-)

No. At this time I don't do any insertion at the call time :-)
But I don't think I will need the parent depth. The current depth will
be sufficient for the trace printing.
