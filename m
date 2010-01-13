Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655Ab0AMOzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0AMOzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630Ab0AMOzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:55:04 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:55810 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab0AMOzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:55:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YC8zpHQ1B8+ZtH+ZSEUoEPSpKi1977UHu39UXzXElwr27y1JetBCEdokmlJihaBtMs
         8FdG/YIsLGkS0wu+hfXC5/W1rTr2YghPFIiAt6uGuJPtKvPp+5OertQG+QvI6jtfDh1D
         kl9297nfOa/O2O9fxL3c3pBWKkKd80C2lDS3k=
Date: Wed, 13 Jan 2010 15:54:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing, function_graph: simplify test for tracing
Message-ID: <20100113145454.GE5036@nowhere>
References: <4B4DB0B6.7040607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DB0B6.7040607@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 07:38:30PM +0800, Lai Jiangshan wrote:
> 
> For function_graph, a calling function is to be traced only when
> it is enabled or it is nested in a enabled function.
> 
> Current code uses TSK_TRACE_FL_GRAPH to test whether it is nested or not.
> read the code, we can get this:
> (trace->depth > 0) <==> (TSK_TRACE_FL_GRAPH is set)
> 
> trace->depth is more explicit to tell that it is nested.
> So we use trace->depth directly and simplify the code.
> 
> No functionality is changed.
> TSK_TRACE_FL_GRAPH is not removed now, it is left for future usage.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---


Looks prety good to me. Nice simplification, the less checks we
have in this hot path, the better.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

