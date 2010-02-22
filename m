Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0BVOsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:48:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab0BVOsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:48:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=Lp5yzKHX74QA:10 a=d4KFlj9k4NoxpZkpZmoA:9 a=rQvN7rc2VuBwiu4S7Axn2ZLIvK0A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
 function_graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100220142054.GA5354@nowhere>
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com>
	 <1265929831.2737.340.camel@localhost.localdomain>
	 <4B749A42.2080703@am.sony.com>
	 <1265934415.2737.344.camel@localhost.localdomain>
	 <20100220142054.GA5354@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 22 Feb 2010 09:48:03 -0500
Message-ID: <1266850083.24271.4404.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 15:21 +0100, Frederic Weisbecker wrote:

> 
> Actually why do we encumber with both tracing_thresh and the funcgraph-exit
> option?
> 
> We could just have the output and the record check tracing_thresh instead
> of the funcgraph-exit option.

You mean just use tracing_thresh during the tracing? We could perhaps
also change the code (and I think this would be beneficial even without
this change) to print the function on exit if it did not have a entry.

That is, in the reading of the trace, keep a depth pointer. For every
"entry" we hit, we add one, and for every "exit" we subtract one (per
cpu). If we go negative, we keep the counter at zero, but write
something like:


  } (sys_write)

Because I always hate it when a trace starts with a bunch of "}" and I
have no idea what functions they are. This would fix that.

Yeah, Tim's trace would have only "} (sys_write)" type syntax but that's
probably fine.

-- Steve


