Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbYJINCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbYJINCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbYJINBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:01:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:19017 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbYJINBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bIxEH7Mw4XOwqJ56kUMJ4z/MNJSXMn82q98O2LGVW58QfDE4osxJCeOpJDSj7kPAiR
         7XNt33YA0roeqc0Kx/Veryx45XhMMkTK6+AamNBkWinm8gg7eiLCF4GnyOQL4c8HRjKh
         hvBgg9OYbdTVlv4vDC0empnps1oAo7LqeMvZ0=
Message-ID: <c62985530810090601m132021b7x8d8743b1aaba990a@mail.gmail.com>
Date: Thu, 9 Oct 2008 15:01:47 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
In-Reply-To: <20081009115407.GD6628@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081006232837.GA1157@basil.nowhere.org>
	 <20081007071544.GC20740@one.firstfloor.org>
	 <20081007152629.GH6384@linux.vnet.ibm.com>
	 <20081007154939.GN20740@one.firstfloor.org>
	 <20081007163401.GJ6384@linux.vnet.ibm.com>
	 <20081007210947.GP20740@one.firstfloor.org>
	 <20081007212215.GN6384@linux.vnet.ibm.com>
	 <20081009010846.GA10188@linux.vnet.ibm.com>
	 <c62985530810090323vd5d08e0haa618ca0cbe0c73f@mail.gmail.com>
	 <20081009115407.GD6628@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> Well, one reason is that I didn't know about it.  ;-)
>
> Does it allow the user to trigger a one-shot trace?  Right now, what
> one does is:
>
>        cat /debug/rcu/rcucb
>
> whenever one wants to see what RCU is up to.  You really don't want to
> see every new value, as that would generate hundreds of trace records
> per second -- per CPU.  What does the user do with the ring-buffer
> tracing enging?
>
>                                                        Thanx, Paul

With a tracer from the unified tracing buffer, you have often one
function, used somewhere in the kernel, which will add periodically
some specific entries. For example mmiotrace receives entries which
contain IO access.
When the user tries to read the entries, he has to read the pipe
/debug/tracing/trace_pipe. During this reading,  the tracing engine
calls a read callback given by the tracer. This read callback is
nothing related to entries on the buffer: if the tracer has to print
something special, this is the ususal function.
Than if the read gave some content, the pipe reading returns. Else,
the tracing engine tells the tracer to format its entries from the
ring buffer. If there is no entries, the pipe reading sleeps and waits
for new entries.

So after some thought, I don't think the current tracing engine is
really adapted for what you want. It is a pipe system and it's not
adapted for your one-shot captures.

Sorry for the noise.

But it only requires few features to add for the unified tracing
engine to support such one-shot tracer.
