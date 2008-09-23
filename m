Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYIWUTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYIWUTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYIWUTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:19:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbYIWUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:19:03 -0400
Date: Tue, 23 Sep 2008 13:17:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tom Zanussi <zanussi@comcast.net>
Cc: a.p.zijlstra@chello.nl, prasad@linux.vnet.ibm.com, mbligh@google.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, compudj@krystal.dyndns.org, rostedt@goodmis.org,
       od@novell.com, fche@redhat.com, hch@lst.de, dwilder@us.ibm.com
Subject: Re: [PATCH 2/3] relay - make subbuf switch replaceable
Message-Id: <20080923131737.d5a8512d.akpm@linux-foundation.org>
In-Reply-To: <1222147650.6875.137.camel@charm-linux>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	<1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	<20080922140740.GB5279@in.ibm.com>
	<1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	<1222147650.6875.137.camel@charm-linux>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 00:27:30 -0500
Tom Zanussi <zanussi@comcast.net> wrote:

> Make the relay sub-buffer switch code replaceable.
>     
> With this patch, tracers now have complete control over the relay
> write (or reserve) path if they choose to do so, by implementing their
> own version of the sub-buffer switch function (switch_subbuf()), in
> addition to their own local write/reserve functions.  Tracers who
> choose not to do so automatically default to the normal behavior.
> 
>
> ...
>
> -EXPORT_SYMBOL_GPL(relay_switch_subbuf);
> +EXPORT_SYMBOL_GPL(switch_subbuf_default_callback);

It would be nice to keep the `relay_' prefix on the exported relay
interface?  Something called `switch_subbuf_default_callback' could
belong to pretty much anywhere in the kernel.


