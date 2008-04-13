Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbYDMBzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbYDMBzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 21:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYDMBzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 21:55:42 -0400
Received: from rv-out-0708.google.com ([209.85.198.251]:7113 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751675AbYDMBzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 21:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GVW/MLK2s6SZlRvjzZyQPCxIFES6LE86mhWLCc/Y5ynIOnNLneD04k6D9opllzaK2syCd0or+P+5ykHOFN9U5IQ6cCrTOXaDA+oif1DlflfkHTiuptT9KWc/yeWheKo/J/riCyBsnmVI2bHOKDNiqS40WS8b/CmN5KzXqgKYjAY=
Message-ID: <86802c440804121855g2a8da2yee02c64daddad9a5@mail.gmail.com>
Date: Sat, 12 Apr 2008 18:55:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [patch 1/2] bootmem: Revert "mm: fix boundary checking in free_bootmem_core"
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080412225850.411927887@symbol.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	 <20080412225850.411927887@symbol.fehenstaub.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 3:33 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> This reverts commit 5a982cbc7b3fe6cf72266f319286f29963c71b9e.
>
>  The intention behind this patch was to make the free_bootmem()
>  interface more robust with regards to the specified range and to let
>  it operate on multiple node setups as well.
>
>  However, it made free_bootmem_core()
>
>   1. handle bogus node/memory-range combination input by just
>      returning early without informing the callsite or screaming BUG()
>      as it did before
>   2. round slightly out of node-range values to the node boundaries
>      instead of treating them as the invalid parameters they are
>
>  This was partially done to abuse free_bootmem_core() for node
>  iteration in free_bootmem (just feeding it every node on the box and
>  let it figure out what it wants to do with it) instead of looking up
>  the proper node before the call to free_bootmem_core().

it seems intel having one box the [0, 4G), [8, 12G] on node 0, and
[4G, 8G) and [12G, 16) on node 1.

YH
