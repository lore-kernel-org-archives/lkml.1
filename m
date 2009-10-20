Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZJTVlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZJTVlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZJTVlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:41:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZJTVla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:41:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=OfseySnpDUcN0F1+m+vyOApXzPOZjuNQvlq98rAOvHOWxWTvYEuySM9KhqjMsaPbl
	8ZpQWSsP+JmVwugc8rRhw==
Date: Tue, 20 Oct 2009 14:41:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
In-Reply-To: <alpine.DEB.1.10.0910171637180.28063@gentwo.org>
Message-ID: <alpine.DEB.1.00.0910201439200.539@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com> <alpine.DEB.1.10.0910161249100.6120@gentwo.org> <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com> <alpine.DEB.1.10.0910162126090.26081@gentwo.org>
 <alpine.DEB.1.00.0910170154580.31277@chino.kir.corp.google.com> <alpine.DEB.1.10.0910171637180.28063@gentwo.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Oct 2009, Christoph Lameter wrote:

> I'd also like to be able to just do a single echo
> to clear the all stats instead of everyone trying to improvise something
> to touch all files. Its highly unlikely that one only wants to zero
> individual counters.  One way to reset them all would suffice.
> 

Ok, once the stat files are moved to their own directory, I'll make a note 
to add a writable `clear' file that will do

	for (i = 0; i < NR_SLUB_STAT_ITEMS; i++)
		clear_stat(s, i);
