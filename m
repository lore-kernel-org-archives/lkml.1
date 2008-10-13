Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYJMOKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYJMOKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYJMOKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:10:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYJMOKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:10:21 -0400
Message-ID: <48F372BA.7020505@linux-foundation.org>
Date: Mon, 13 Oct 2008 09:09:30 -0700
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nathalie.furmento@labri.fr
Subject: Re: [PATCH] mm: use a radix-tree to make do_move_pages() complexity
 linear
References: <48EDF9DA.7000508@inria.fr> <20081010125010.164bcbb8.akpm@linux-foundation.org> <48EFB6E6.4080708@inria.fr> <48EFBBE9.5000703@linux-foundation.org> <48F069B8.6050709@inria.fr>
In-Reply-To: <48F069B8.6050709@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:
> * One thing that bothers me is move_pages() returning -ENOENT when no
> page are given to migrate_pages(). I don't see why having 100/100 pages
> not migrated would return a different error than having only 99/100
> pages not migrated. We have the status array to place -ENOENT for all
> these pages. If the user doesn't know where his pages are allocated, he
> shouldn't get a different return value depending on how many pages were
> already on the right node. And actually, this convention makes
> user-space application harder to write since you need to treat -ENOENT
> as a success unless you already knew for sure where your pages were
> allocated. And the big thing is that this convention makes the chunking
> painfully/uselessly more complex. Breaking user-ABI is bad, but fixing
> crazy ABI...
>   
I do not think that move_pages() is used that frequently. Changing the 
API slightly as you suggest would not be that big of a deal.

