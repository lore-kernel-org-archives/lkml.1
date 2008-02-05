Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYBEXNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYBEXNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbYBEXN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:13:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:6079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbYBEXNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:13:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=nFpgvveyI50B2xGhWvjDTW2NeU08iFOZKJgOwvUGK5fzqk6UUnJcMPXufyfZUZSzr
	RUhs9YWmlxUqEjkXKz8Ig==
Date: Tue, 5 Feb 2008 15:09:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeff Davis <linux@j-davis.com>
cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@qumranet.com>
Subject: Re: [PATCH] badness() dramatically overcounts memory
In-Reply-To: <1202252561.24634.64.camel@dogma.ljc.laika.com>
Message-ID: <alpine.DEB.1.00.0802051507460.18347@chino.kir.corp.google.com>
References: <1202182480.24634.22.camel@dogma.ljc.laika.com>  <47A7E282.1080902@linux.vnet.ibm.com> <1202252561.24634.64.camel@dogma.ljc.laika.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Jeff Davis wrote:

> > The interesting thing is the use of total_vm and not the RSS which is used as
> > the basis by the OOM killer. I need to read/understand the code a bit more.
> 
> RSS makes more sense to me as well.
> 
> To me, it makes no sense to count shared memory, because killing a
> process doesn't free the shared memory.
> 

Andrea Arcangeli has patches pending which change this to the RSS.  
Specifically:

	http://marc.info/?l=linux-mm&m=119977937126925
