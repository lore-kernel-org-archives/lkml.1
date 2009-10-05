Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZJEMQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZJEMQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZJEMQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:16:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZJEMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:16:15 -0400
Subject: Re: futex question
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anirban Sinha <ani@anirban.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
In-Reply-To: <alpine.LFD.2.00.0910051358060.2646@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>
	 <20091001092218.GH15345@elte.hu>
	 <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>
	 <4AC68F13.8050601@us.ibm.com>
	 <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>
	 <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>
	 <4AC8CF32.8060108@anirban.org>
	 <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>
	 <1254738974.26976.24.camel@twins> <1254743934.26976.42.camel@twins>
	 <alpine.LFD.2.00.0910051358060.2646@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Oct 2009 14:18:39 +0200
Message-Id: <1254745119.26976.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 13:59 +0200, Thomas Gleixner wrote:
> Stared at the same place a minute ago :) But still I wonder if it's a
> good idea to silently release locks and set the state to OWNERDEAD
> instead of hitting the app programmer with a big clue stick in case
> the app holds locks when calling execve().

Agreed, I rather like the feedback. With regular exit like things
there's just not much we can do to avoid the mess, but here we can
actually avoid it, seems a waste not to do so.

