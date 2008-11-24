Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYKXRQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYKXRQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYKXRQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:16:27 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:33053 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYKXRQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:16:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=b6RxePHZV03v9asGpICtrApZB3w70WfL7CnlzPdF5I5yrKl9mWfcXM7DiBT+6froYx
         xyUZZ/itMSAQhq9tG8giNvypVFAXniK25A0ZhY4Bbv0jHqNCwavngBZECYWK55mQUmG8
         8hOFCVLjjQlmiZNiS/JdKRmUasPfFzXNoCvkE=
Message-ID: <c62985530811240916u53426872p22d352ed32b4f39c@mail.gmail.com>
Date: Mon, 24 Nov 2008 18:16:25 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Human readable output for function return tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081124162719.GA11532@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
	 <20081124162719.GA11532@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Ingo Molnar <mingo@elte.hu>:
> that's OK i think. It will double the number of events, but will
> simplify everything immensely - especially if we have small
> imperfections in the callgraph arising out of IRQ entries.

Great!

> Note that we _could_ render it all from the return events alone,
> because we have the full callgraph available. But it would be either
> very memory-intense or very CPU-intense: we'd either have to buffer up
> all the return events in a reverse-stack sort of construct (which
> could grow much larger than the return stack itself), or we'd have to
> reconstruct it on the fly by constantly scanning forwards to discover
> the context of the printout. Both can have pretty ugly worst-case
> behavior with certain call graph layouts.


Yes, too much complex, too much error prone.... And such a thing
would have been better done from user space...

> So i think you made a good call - lets keep it simple for now.
>
> Also, do you have any thoughts about how to extend the return-tracer
> to 64-bit x86? It should work pretty well i think - the return value
> has to be extended to 64 bits but that's pretty much all.


Yes, I'm currently burning a 64 bits distro :-)
Very few things should be added or modified to work on 64. The most adds
will be in entry64.S and perhaps very few things in ftrace.c ...
That should come soon.

Note that I plan to adapt it for other archs too such as ARM and Sparc64, but
perhaps more likely for 2.6.30,  I will see.....

Thanks :-)
