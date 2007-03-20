Return-Path: <linux-kernel-owner+w=401wt.eu-S965254AbXCTQdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254AbXCTQdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXCTQdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:33:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35507 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338AbXCTQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:33:28 -0400
Message-ID: <46000C8B.1090600@bull.net>
Date: Tue, 20 Mar 2007 17:32:11 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH 2.6.21-rc3-mm2 3/4] futex_requeue_pi optimization
References: <20070313095203.154246923@bull.net>	 <20070313095548.003786249@bull.net> <1174040046.7124.27.camel@twins>	 <45FFFE72.6000300@bull.net> <1174406134.16478.37.camel@twins>
In-Reply-To: <1174406134.16478.37.camel@twins>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/03/2007 17:35:25,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/03/2007 17:35:27,
	Serialize complete at 20/03/2007 17:35:27
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :

> 
> Unfortunately not, nonlinear vmas don't have a linear relation between
> address and offset. What you would need to do is do a linear walk of the
> page tables. But even that might not suffice if nonlinear vmas may form
> a non-injective, surjective mapping.
> 
> /me checks..
> 
> Hmm, yes that seems valid, so in general, this reverse mapping does not
> uniquely exist for non-linear vmas. :-(
> 
> What to do... disallow futexes in nonlinear mappings, 

> store the address in the key?   <<

That seems to be the only solution... :-/

> 
> the vma_prio_tree would be able to give all vmas associated with a
> mapping.
> 

Thanks for your help.

-- 
Pierre
