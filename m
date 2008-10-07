Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYJGPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYJGPW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYJGPWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:22:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbYJGPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:22:18 -0400
Message-ID: <48EB7E59.7070308@linux-foundation.org>
Date: Tue, 07 Oct 2008 10:20:57 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] SLOB's krealloc() seems bust
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>	 <48EB6D2C.30806@linux-foundation.org> <1223391655.13453.344.camel@calx>
In-Reply-To: <1223391655.13453.344.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:

> We can't dynamically determine whether a pointer points to a kmalloced
> object or not. kmem_cache_alloc objects have no header and live on the
> same pages as kmalloced ones.

Could you do a heuristic check? Assume that this is a kmalloc object and then
verify the values in the small control block? If the values are out of line
then this cannot be a kmalloc'ed object.



