Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0BVSOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:14:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:6257 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0BVSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:14:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rrvS1CQnyUpLf8KXAbIM9KYJyEimxNMVq+Anx+TALpOgWoyxmvn3TT5/+sXRYfUA5S
         /VF9GH53bVkl8o6kIdofptsOQYz4SvtoQKLRjICauY7JMb4nO2ojdHDTmQH8KKhn7qBt
         YiZ6cPTa0dJf9bCfIgOtiG8+vuxEPQH7T0SFw=
Date: Mon, 22 Feb 2010 19:14:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
	function_graph tracer
Message-ID: <20100222181400.GE5055@nowhere>
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com> <1265929831.2737.340.camel@localhost.localdomain> <4B749A42.2080703@am.sony.com> <1265934415.2737.344.camel@localhost.localdomain> <20100220142054.GA5354@nowhere> <1266850083.24271.4404.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266850083.24271.4404.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:48:03AM -0500, Steven Rostedt wrote:
> On Sat, 2010-02-20 at 15:21 +0100, Frederic Weisbecker wrote:
> 
> > 
> > Actually why do we encumber with both tracing_thresh and the funcgraph-exit
> > option?
> > 
> > We could just have the output and the record check tracing_thresh instead
> > of the funcgraph-exit option.
> 
> You mean just use tracing_thresh during the tracing? We could perhaps
> also change the code (and I think this would be beneficial even without
> this change) to print the function on exit if it did not have a entry.
> 
> That is, in the reading of the trace, keep a depth pointer. For every
> "entry" we hit, we add one, and for every "exit" we subtract one (per
> cpu). If we go negative, we keep the counter at zero, but write
> something like:
> 
> 
>   } (sys_write)



Why not, looks like a good idea.


> 
> Because I always hate it when a trace starts with a bunch of "}" and I
> have no idea what functions they are. This would fix that.


Agreed.



> Yeah, Tim's trace would have only "} (sys_write)" type syntax but that's
> probably fine.



May be. Or we can couple your above solution and check if tracing_thresh > 0,
in which case we just zap the "}".

