Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZAIS7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZAIS7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZAIS72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:59:28 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:3991 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZAIS70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:59:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vHp/wMhPMptgQ1/o6eCA7jjT4wi41GCqcyxiStC0ujBW8X24/321A/YFx6QA0s2JSH
         rpDi+HEN5vdsJrPfU2Iy0/WpHX+SW+uaivzN57VkEdLCSKwPHAnpIWMpQky8CyEHwgiv
         9BpEE9r5oEtrpSP+uUjhksZbMX0nuv1oOFleI=
Message-ID: <84fc9c000901091059v65265413wda053d3ce5b0d17a@mail.gmail.com>
Date: Fri, 9 Jan 2009 19:59:22 +0100
From: "Richard Guenther" <richard.guenther@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Dirk Hohndel" <hohndel@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "jim owens" <jowens@hp.com>, "Chris Mason" <chris.mason@oracle.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Nick Piggin" <npiggin@suse.de>,
       "Peter Morreale" <pmorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, jh@suse.cz
In-Reply-To: <20090109181952.GI26290@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090109130057.GA31845@elte.hu> <20090109153508.GA4671@elte.hu>
	 <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org>
	 <20090109172011.GD26290@one.firstfloor.org>
	 <20090109172801.GC6936@parisc-linux.org>
	 <20090109174719.GG26290@one.firstfloor.org>
	 <20090109173914.GD6936@parisc-linux.org>
	 <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
	 <20090109181952.GI26290@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 7:19 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> So we do have special issues. And exactly _because_ we have special issues
>> we should also expect that some compiler defaults simply won't ever really
>> be appropriate for us.
>
> I agree that the kernel needs quite different inlining heuristics
> than let's say a template heavy C++ program. I guess that is
> also where our trouble comes from -- gcc is more tuned for the
> later. Perhaps because the C++ programmers are better at working
> with the gcc developers?
>
> But it's also not inconceivable that gcc adds a -fkernel-inlining or
> similar that changes the parameters if we ask nicely. I suppose
> actually such a parameter would be useful for far more programs
> than the kernel.

I think that the kernel is a perfect target to optimize default -Os behavior for
(whereas template heavy C++ programs are a target to optimize -O2 for).
And I think we did a good job in listening to kernel developers if once in
time they tried to talk to us - GCC 4.3 should be good in compiling the
kernel with default -Os settings.  We, unfortunately, cannot retroactively
fix old versions that kernel developers happen to like and still use.

Richard.
