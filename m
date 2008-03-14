Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYCNDDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYCNDDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 23:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYCNDDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 23:03:40 -0400
Received: from hs-out-0708.google.com ([64.233.178.240]:11520 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYCNDDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 23:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qVPk2tyQGg6zovG4lXV7dUPHsXzNO5GsmbDg1FCsKGic0z8rSLLjP+k3Xw60G1j0HsRxHERzhiuSBUfZbSyYVZbDld3k4vY/rDsSl8054u+D41PKOY41Mgisvd4FCxoxSL4m5DLtN5/z08dZQ9CnI43SorMdodEN6cybToKoUmI=
Message-ID: <86802c440803132003j4937546di1dc89cb51985cedb@mail.gmail.com>
Date: Thu, 13 Mar 2008 20:03:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>
In-Reply-To: <87zlt22erg.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
	 <20080314103431.ff07070c.kamezawa.hiroyu@jp.fujitsu.com>
	 <86802c440803131835u4e506d69l4f116eb49d9ee9b2@mail.gmail.com>
	 <20080314105529.79921546.kamezawa.hiroyu@jp.fujitsu.com>
	 <86802c440803131900j30ef490bk1923fdd219433535@mail.gmail.com>
	 <20080314113646.d73066f7.kamezawa.hiroyu@jp.fujitsu.com>
	 <87zlt22erg.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 7:58 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi,
>
>
>  KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
>
>  > Background:
>  > - reserve_bootmem is called for *reserve* memory before bootmem allocator.
>  > - It specifies <address, size>.
>  > - Because <addrees, size> are argments, memory hole in <address, size> is not
>  >   problem here.
>  >
>  > Before change,
>  > - reseve_bootmem() only works for Node(0)
>  >
>  > After change
>  > - reserve_bootmem() works on sutiable nodes for <address, size>
>  > - It can spread accross among prural nodes.
>
>  After the change it will iterate over all nodes, reserving the range
>  `address to address+size' on each of them.

 +     /* out of range */
 +     if (addr >= bdata->node_boot_start && addr < bdata->last_success)
 +             return;

out of range will bail out...

YH
