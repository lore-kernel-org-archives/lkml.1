Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZCJAMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZCJAMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 20:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZCJAMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 20:12:35 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:34386 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZCJAMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 20:12:35 -0400
Date: Tue, 10 Mar 2009 00:12:22 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [TIP,BISECTED] Negative nice values have become big positive numbers
Message-ID: <20090310001222.GA1843@silver.sucs.org>
References: <20090308231850.GB24445@silver.sucs.org> <20090309201503.GA5010@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309201503.GA5010@nowhere>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 09:15:04PM +0100, Frederic Weisbecker wrote:
> On Sun, Mar 08, 2009 at 11:18:50PM +0000, Sitsofe Wheeler wrote:
> > Formally negative nice values have started become very big in positive
> > integers in -tip kernels:
> > 
> >     2 root      15 2147483647     0    0    0 S  0.0  0.0   0:00.00 kthreadd    
> 
> The weird thing here is that number: 2147483647
> It is 0xefffffff
> Which means -1 without the highest bit (the sign).
> I really don't know how it could have happened.
> 
> Anyway, I caught something in the signedness bits from my patch that unifies
> the format decoding.
> I've never seen your bug on my machine. But I note you have a 32 bits CPU.
> Mine is 64 bits with a 64 bits kernel. Perhaps some weird signedness related things
> happened because of the signedness bug that the following patch fixes.
> 
> Can you please give it a try?

This seems to have fixed the problem (unless I'm mistaken):
    2 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthreadd           

Thanks!

-- 
Sitsofe | http://sucs.org/~sits/
