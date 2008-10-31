Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYJaCnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYJaCnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYJaCno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:43:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYJaCno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:43:44 -0400
Date: Thu, 30 Oct 2008 22:43:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
In-Reply-To: <c62985530810301705h356decf8oea0db02def2ab3c1@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810302241420.21031@gandalf.stny.rr.com>
References: <490A08E3.2040201@gmail.com>  <alpine.DEB.1.10.0810301556010.19996@gandalf.stny.rr.com> <c62985530810301705h356decf8oea0db02def2ab3c1@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 31 Oct 2008, Fr?d?ric Weisbecker wrote:

> 2008/10/30 Steven Rostedt <rostedt@goodmis.org>:
> > What about storing the return addresses on the bottom of the stack?
> > That is, start at task->stack + sizeof(thread_info), and stack up on that.
> > Be careful, there might already be users of that area. This will also need
> > to be arch dependent.
> 
> But how could I assume there is enough space behind this address to store a long
> stack of functions calls for a same thread?
> And if an interrupt is raised, would a reference to "current task" be
> really consistant?
> 
> I don't know much about the bottom stack of the tasks, I'm not sure
> about how much
> space I can use inside... I should study this field. Who could be the
> potential users of this area?
> 

Because it is the real stack ;-)

Before adding, test to see if the real stack pointer is getting close. If 
it is, then there's probably more issues.  You can run the stack_tracer to 
see how much stack is available too.

-- Steve

