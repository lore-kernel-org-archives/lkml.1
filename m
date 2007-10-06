Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbXJFVNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbXJFVNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764456AbXJFVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:12:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:65065 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764080AbXJFVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=sN4jN+eGl6nSucGvJM0b5Bs+X8CFqXrnkEFrkdn/aCKmV1b8Zo48VF8Ug9FtYCi0RKSHuVtKn9McbsLoTChUtRiKqDN06uGkMSO+fbqDfDZrNivKP7TIe9oEsT/2EA1xTR4rStzL5H+sYowqakCXdC7BWs6yugyd8WWSftMkc+Q=
Date: Sun, 7 Oct 2007 01:12:38 +0400
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Oops] on 2.6.23-rc9 sysRq Show Tasks (t)
Message-ID: <20071006211238.GB7924@martell.zuzino.mipt.ru>
References: <20071006201405.GA2530@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006201405.GA2530@Ahmed>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 10:14:06PM +0200, Ahmed S. Darwish wrote:
> Pressing sysRq+T always produce an Oops for every running system task (94 
> Oopses, that's a record ;)).

uh-oh. For every sleeping task, I think.

> The bug is 100% reproducable. Should I begin bisecting/investigating the 
> issue or it's a known problem ?

Start with some old kernel, like mmm.. 2.6.0. The fact that same behaviour
was present there may make you think about faulty assumptions you've
made.

> [  226.309874] SysRq : Show State
> [  226.309948]   task                PC stack   pid father
> [  226.310105] init          S c1465b64     0     1      0
> [  226.310195]        c1465b54 00000082 00000286 c1465b64 c04255c0 c03c3ec0 00000000 00000286 
> [  226.310414]        c1465b64 fffd689a 0000000b 00000000 c02e8fda c1537040 00000292 c0425ab4 
> [  226.310664]        c0425ab4 fffd689a c0123cd0 c14634f0 c04255c0 00000800 c1465f9c c0176bf5 
> [  226.310914] Call Trace:
> [  226.310995]  [<c02e8fda>] schedule_timeout+0x4a/0xc0
