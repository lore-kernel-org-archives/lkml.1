Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbZFIV5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbZFIV5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbZFIV5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:57:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbZFIV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:57:20 -0400
Date: Tue, 9 Jun 2009 14:56:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
Subject: Re: [RFC PATCH 1/1] smi_detector: A System Management Interrupt
 detector
Message-Id: <20090609145607.d8944778.akpm@linux-foundation.org>
In-Reply-To: <1244584201.30733.93.camel@localhost.localdomain>
References: <20090531163117.502167374@jonmasters.org>
	<20090531163343.771922592@jonmasters.org>
	<20090601205720.825d3048.akpm@linux-foundation.org>
	<1244584201.30733.93.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Jun 2009 17:50:01 -0400
Jon Masters <jonathan@jonmasters.org> wrote:

> > > +	if (0 != err)
> > 
> > 	if (err != 0)
> > 
> > or
> > 
> > 	if (err)
> > 
> > would be more typical.
> 
> The former runs the risk of assignment,

yup, which is why gcc will warn if you do

	if (err = 0)

If you really meant to do that, then gcc can be silenced by
double-parenthesising.  We consider this "good enough" for kernel
purposes, so we generally don't use the `if (CONSTANT == variable)' trick.


> whereas <value> != <variable>
> will generate a compiler error if it goes wrong, so I trained myself to
> always do that. The desired value is zero, so I prefer to show that in
> the test, but I have changed it following your advice anyway - it's like
> how I have to force myself not to use '{' '}' on single line
> if-statements despite generally doing so, again for safety :)
