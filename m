Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZA0Pql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZA0Pql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZA0Pqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:46:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbZA0Pqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:46:32 -0500
Date: Tue, 27 Jan 2009 07:45:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle McMartin <kyle@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] make checkpatch warn about access to current->comm
In-Reply-To: <20090127053920.GB5034@bombadil.infradead.org>
Message-ID: <alpine.LFD.2.00.0901270741490.3123@localhost.localdomain>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <AuEeLWHZjFB@christoph> <20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090126211655.c7287768.akpm@linux-foundation.org> <20090127051919.GA5034@bombadil.infradead.org>
 <20090126212615.2658b29e.akpm@linux-foundation.org> <20090126212918.d4770115.akpm@linux-foundation.org> <20090127053920.GB5034@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Jan 2009, Kyle McMartin wrote:
> 
> Suggest using the get_task_comm accessor versus direct access to
> current->comm.

I think "current->comm" is fine, and not racy.

It only gets racy when you ask for the name of _another_ task.

And quite frankly, I don't think anybody but /proc does that anyway. I 
think this whole "get_task_comm()" thing is overrated. Most people are 
better off doing just "current->comm".

		Linus
