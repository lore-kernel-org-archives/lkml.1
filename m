Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbYG2MCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbYG2MCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYG2MCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:02:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36988 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbYG2MCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:02:46 -0400
Date: Tue, 29 Jul 2008 14:02:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
Message-ID: <20080729120237.GH30344@one.firstfloor.org>
References: <488E534F.2030204@goop.org> <488E5455.6010901@goop.org> <20080729021215.GG30344@one.firstfloor.org> <488EB8BE.8050806@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488EB8BE.8050806@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:29:18PM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >>>Now that normal smp_function_call is no longer an enormous bottleneck, 
> >>>      
> >
> >Hmm? It still uses a global lock at least as of current git tree.
> 
> Yes, but it's only held briefly to put things onto the list.  It doesn't 
> get held over the whole IPI transaction as the old smp_call_function 
> did, and the tlb flush code still does.  RCU is used to manage the list 
> walk and freeing, so there's no long-held locks there either.

If it bounces regularly it will still hurt.

-Andi
