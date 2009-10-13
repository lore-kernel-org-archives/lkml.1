Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbZJMS6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbZJMS6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760964AbZJMS6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:58:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZJMS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:58:14 -0400
Subject: Re: [tip:timers/tracing] hrtimer: Add tracepoint for hrtimers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20091013184150.GA17492@elte.hu>
References: <4A7F8B2B.5020908@cn.fujitsu.com>
	 <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org>
	 <1255404309.7113.948.camel@gandalf.stny.rr.com>
	 <20091013070853.GA13175@elte.hu>
	 <1255439822.7113.1541.camel@gandalf.stny.rr.com>
	 <20091013132656.GA12292@elte.hu>
	 <1255442557.7113.1623.camel@gandalf.stny.rr.com>
	 <20091013184150.GA17492@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 14:56:14 -0400
Message-Id: <1255460174.7113.2115.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 20:41 +0200, Ingo Molnar wrote:

> > But still, we need to build a way to convert big endian to little, as 
> > well as perhaps converting 32bit to 64 bit longs. As well as vice 
> > versa.
> 
> Exporting the print line as C in a convenient way does not in any way 
> make it more difficult to define endianness and bit size - we have to do 
> that anyway. It's largely orthogonal.

The way I do it now, is basically making a C interpreter. This can
easily handle word size and endianess (I have those exported too, and
can handle differences between host and file).

But to export the "printf" as a C function, that C function will need to
know a way what size a long is, as well as how to convert endianess.

I'm not really sure how to go about doing something like this
automatically. Every event will need its own C function to convert.
Sounds more like what Mathieu was describing.

We still don't have a way to handle enums and structures (like ktime).

-- Steve


