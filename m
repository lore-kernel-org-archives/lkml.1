Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbZINRJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbZINRJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbZINRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:09:25 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:41361 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbZINRJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=svg36bSwrvQhosQAXE/8qOoa7cUu2gm99Vt9J/JSyesu7xgDNbLIYjY1DUtcxC/+p0
         uuth85zdr/FqAhEAXWdUjS5Fkd1mS/BdJVFhWfujWYWO4GsZnqsoLmqypO0FnO39x8VL
         XZBTYyvHrURzsXRU1RLS7elDFOqSlNVmzBUJc=
MIME-Version: 1.0
In-Reply-To: <1252941416.2964.143.camel@localhost.localdomain>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	 <1249403089.4634.139.camel@localhost.localdomain>
	 <20090912165300.9d257283.sfr@canb.auug.org.au>
	 <20090912073906.GA3972@elte.hu> <1252753957.12217.10.camel@ht.satnam>
	 <1252941416.2964.143.camel@localhost.localdomain>
Date: Mon, 14 Sep 2009 10:09:27 -0700
X-Google-Sender-Auth: 72f7c1e4e3799dc2
Message-ID: <70318cbf0909141009v46581785m4c70edf31fcb79fa@mail.gmail.com>
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree 
	build warning)
From: Christopher Li <sparse@chrisli.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
       Josh Triplett <josh@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 8:16 AM, Steven Rostedt <srostedt@redhat.com> wrote:
> static void func(int size_me) {
>        char array[size_me];
>
>        memcpy(array, "hello", size);
> };
>
> and sparse failed on it as well. Note, you need to have something call
> func, or sparse will ignore it.

Gcc allows variable size. Sparse expects the size of an array is constant.
For the kernel using variable array size is consider bad. Because the kernel
has very limited stack size. (8K if I remember correctly). Using dynamic array
is very easy to overflow the stack without realizing it.

It deserves a warning. I agree the warning message can use a better description
though.

Chris
