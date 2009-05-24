Return-Path: <linux-kernel-owner+w=401wt.eu-S1760517AbZEXWQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517AbZEXWQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbZEXWQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:16:16 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:51639 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760450AbZEXWQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NK9XUAKJLAsLru3ajjAbYbcSeX0v4d0CK080YpAsUuILIUK+1GIxSxVuA3hq6FgN92
         9rJpl9U5i4cguxKnjuWx+7AR25SwJfrJ1W6FEPHgm4PYF213159CyrjCHNre4X5DSdUV
         dbpiLmr1+wLQ9X5QPcEXX7VBcX2ASABUf5UE0=
Date: Mon, 25 May 2009 00:16:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: fork() && ftrace_graph_exit_task()
Message-ID: <20090524221615.GG6471@nowhere>
References: <20090521195330.GA13604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521195330.GA13604@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 09:53:30PM +0200, Oleg Nesterov wrote:
> What if the task with ->ret_stack != NULL calls fork(), and
> copy_prcoess() fails after successfull dup_task_struct() ?
> 
> bad_fork_free: -> free_task()->ftrace_graph_exit_task() will
> free the parent's ->ret_stack copied by arch_dup_task_struct(),
> no?
> 
> Oleg.
>


Good catch, that's a rare situation but very dangerous.

I will fix it, thanks for your report!

Frederic.

