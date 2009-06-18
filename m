Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZFREeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZFREeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 00:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZFREeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 00:34:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZFREeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 00:34:03 -0400
Date: Thu, 18 Jun 2009 00:34:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jake Edge <jake@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: problem with function_graph self-test?
In-Reply-To: <20090617214303.483fe0a0@chukar>
Message-ID: <alpine.DEB.2.00.0906180000490.6890@gandalf.stny.rr.com>
References: <20090616122603.6a628097@chukar> <alpine.DEB.2.00.0906172312450.6890@gandalf.stny.rr.com> <20090617214303.483fe0a0@chukar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 17 Jun 2009, Jake Edge wrote:

> you don't run into this under your "normal" configs?

Doing some google research, I came across this:

 http://www.mail-archive.com/gcc@gcc.gnu.org/msg33101.html

   and 

 http://gcc.gnu.org/ml/gcc-patches/2008-06/msg00025.html

and if I disable OPTIMIZE_FOR_SIZE I get this:

00000420 <timer_stats_update_stats>:
 420:   55                      push   %ebp
 421:   89 e5                   mov    %esp,%ebp
 423:   83 e4 e0                and    $0xffffffe0,%esp

Which gives me the right results. Perhaps we need to make FUNCTION_GRAPH 
depend on !OPTIMIZE_FOR_SIZE, or perhaps if it is only i386 then
 depend on !(OPTIMIZE_FOR_SIZE && X86_32)  :-/


-- Steve
