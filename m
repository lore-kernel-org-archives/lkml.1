Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYBGGyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYBGGyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYBGGyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:54:31 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbYBGGy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:54:29 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=kXFDNhFoVqqhnWHoqEHHui6X8stZnTW2unV99xhhlPO2JDoewVOBR6DMazWX1uMm8
	lGyfBqwxZCU0xNkFoRmDQ==
Date: Wed, 6 Feb 2008 22:54:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sven Wegener <sven.wegener@stealer.net>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Make the synchronization interval controllable
In-Reply-To: <Pine.LNX.4.64.0802062329150.15729@titan.stealer.net>
Message-ID: <alpine.DEB.1.00.0802062253290.31533@chino.kir.corp.google.com>
References: <1202333990-19359-1-git-send-email-sven.wegener@stealer.net> <alpine.DEB.1.00.0802061409130.7879@chino.kir.corp.google.com> <Pine.LNX.4.64.0802062329150.15729@titan.stealer.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Sven Wegener wrote:

> Negative values will be converted to MAX_JIFFY_OFFSET by msecs_to_jiffies and
> result in a very long interval. A too long interval will be a good way to get
> your system OOM. We could use an unsigned int or even restrict the value with
> proc_dointvec_minmax. I'd prefer the latter, that's what I already had in my
> mind and it also protects from unintentionally choosing a too long interval.
> 

Yeah, you're definitely going to want an upper bound on acceptable values 
and not allow anything negative for the aforementioned reason.

		David
