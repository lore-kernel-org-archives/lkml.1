Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZCWFS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZCWFS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZCWFSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:18:48 -0400
Received: from ozlabs.org ([203.10.76.45]:54911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZCWFSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:18:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: oops in tracepoint_update_probe_range()
Date: Mon, 23 Mar 2009 15:48:14 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090319160003.GA25000@Krystal> <alpine.DEB.2.00.0903191219260.16987@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903191219260.16987@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231548.15631.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 March 2009 02:50:30 Steven Rostedt wrote:
> > Are we supposed to assume that module.c allows loading modules with
> > incompatible struct module at all ? That sounds like we would be trying
> > to fix up things broken by the module loader in the first place.
> 
> Then it should be WARN_ON, no need to lock up a box hard, and give the 
> user in X with no serial, no idea why the box just locked up.

In case anyone wonders, I don't care in general (though I won't protest if
anyone else wants to put checks in their code).  You can crash in all kinds of exotic ways using the wrong modules.  If you are a kernel dev, modversions will often save you (eg. struct module changing).  If not, the kernel version  string should change.  Otherwise, someone's just messing with you.

Hope that helps,
Rusty.
