Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYKXSPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYKXSPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYKXSP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:15:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44455 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYKXSP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:15:26 -0500
Date: Mon, 24 Nov 2008 16:15:15 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Human readable output for function return tracer
Message-ID: <20081124181515.GG26466@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 24, 2008 at 03:39:45PM +0100, Frédéric Weisbecker escreveu:
> Hi,
> 
> I'm planning to apply an idea proposed by Ingo to make the output on
> the function return tracer
> more "eyes-parsable".
> The idea consists on a trace which has flow similar to C code:
> 
> func1() {
>     func2() {
>         func3() {
>         }
>     }
>     func4() {
>     }
> }
> 
> (With time of execution added on closing braces).

I do something like that in my ctracer tool[1], take a look at one of
the callgraphs:

http://oops.ghostprotocols.net:81/ostra/dccp/tx/

To save space I the above sequence is represented as:

 func1() {	
     func2() {
         func3()                   1us
     }                             5us
     func4()                       5us
 }                                12us

I.e. the leaf functions doesn't use {}

> The problem is that the traces arrive in the reverse order, according
> to the fact that functions
> are traced on return.
> The order corresponding to the above example would be as the following:
> 
> func3, func2, func4, func1

On ctracer I didn't had this problem as I don't trace all functions,
just the ones that receive as one of its parameters a pointer to the
desired struct, and this pointer is present in all the trace buffer
entries, so as part of postprocessing it separates the callgraphs per
object.

- Arnaldo

[1] git://git.kernel.org/pub/scm/linux/kernel/git/acme/pahole.git
    http://git.kernel.org/?p=linux/kernel/git/acme/pahole.git;a=blob_plain;f=README.ctracer
