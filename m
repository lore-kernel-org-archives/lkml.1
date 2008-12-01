Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYLAB7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYLAB7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 20:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYLAB67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 20:58:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33084 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbYLAB66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 20:58:58 -0500
Subject: Re: dynamic function tracing
From: Steven Rostedt <srostedt@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20081128101922.451e254a@infradead.org>
References: <20081128101922.451e254a@infradead.org>
Content-Type: text/plain
Organization: Red Hat
Date: Sun, 30 Nov 2008 20:58:50 -0500
Message-Id: <1228096730.4886.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-11-28 at 10:19 -0800, Arjan van de Ven wrote:
> Hi,
> 
> I like the new function trace format with the {}'s a lot.. but I would
> like to use it in a way I don't think would work with dynamic tracing.
> 
> What I would like to do (read: usecase) is mark a function as
> interesting (because it has some performance issue or whatever),
> and then I want to get all functions it calls (recursive) traced
> automatically for the duration of that function.
> 
> This might be implementable by, on hitting the function to trace,
> patching all trace points with a function that checks if it's this
> thread (eg this "current"), and if so, traces the call. 
> I realize it's not going to be super cheap, so it needs to be one-shot,
> but it'll form a really strong usecase in practice...

It would not be wise to enable the function pointer at that moment. But
what we could do is have a function trace enabled that will flag when a
function is hit. Then it could start tracing all functions until it
returns. This would be possible.

What we need is a better way to attach the function tracer with the
function graph.

-- Steve


