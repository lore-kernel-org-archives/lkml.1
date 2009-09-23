Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbZIWXnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbZIWXnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZIWXnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:43:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbZIWXnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:43:40 -0400
Date: Wed, 23 Sep 2009 16:43:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "kmod: fix race in usermodehelper code"
In-Reply-To: <20090923230255.GA18878@Chamillionaire.breakpoint.cc>
Message-ID: <alpine.LFD.2.01.0909231642400.3303@localhost.localdomain>
References: <20090923230255.GA18878@Chamillionaire.breakpoint.cc>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Sep 2009, Sebastian Andrzej Siewior wrote:
> 
> The pach is wrong IMHO. UMH_WAIT_EXEC is called with VFORK what ensures
> that the child finishes prior returing back to the parent. No race. The patch
> makes it even worse because it does the thing it claims not do:
> - It calls ->complete() on UMH_WAIT_EXEC
> - the complete() callback may de-allocated subinfo

Yeah, I think you're right. That commit is bogus. Thanks for noticing.

		Linus
