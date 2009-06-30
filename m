Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZF3Kyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZF3Kyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZF3KyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:54:23 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45973 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZF3KyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nOnq1farhk07Fbica8W/Abp+6oe9kcSJxDAbZglZAt13p1LR0GreKxh7vL3hRVZiRZ
         1Q66n7IOi0BxZQMWwxQbpGhJu6C+TmLoaN+3ISs5imgBV+0DXd01IDCjr4qaeKL5PZhi
         YAR8wl2pBSjmZyvPc53cL546QYlbWDCtoks6g=
Date: Tue, 30 Jun 2009 12:54:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] trace_function_graph: consumed event may be invalid
Message-ID: <20090630105416.GA5249@nowhere>
References: <4A49C96C.6070305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A49C96C.6070305@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 04:14:36PM +0800, Lai Jiangshan wrote:
> 
> In get_return_for_leaf() {
> 	......
> 	ring_buffer_consume()
> 	......
> 	access to @curr->ent.pid
> }
> 
> @curr is saved at consumed event, if this event is the last event
> in the page, the ring_buffer may reuse the page. It will become invalid.


Indeed!

 
> Is there any other code to ensure it valid when we `cat trace_pipe`?
> 
> Lai.


The only solution I see is to do a copy of the entry before consuming it.
I'll try that, thanks for your report!

Frederic.

