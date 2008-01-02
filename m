Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbYABXxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbYABXxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYABXxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:53:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYABXxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:53:31 -0500
Date: Wed, 2 Jan 2008 18:53:26 -0500
From: Rik van Riel <riel@redhat.com>
To: "minchan Kim" <barrioskmc@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: why do we call clear_active_flags in shrink_inactive_list ?
Message-ID: <20080102185326.66a3a883@bree.surriel.com>
In-Reply-To: <44c63dc40712292332s4a2e7e4aief37a2dbdd03fc21@mail.gmail.com>
References: <44c63dc40712292332s4a2e7e4aief37a2dbdd03fc21@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007 16:32:42 +0900
"minchan Kim" <barrioskmc@gmail.com> wrote:

> In 2.6.23's shrink_inactive_list function, why do we have to call
> clear_active_flags after isolate_lru_pages call ?
> IMHO, If it call isolate_lru_pages with "zone->inactive_list", It can
> be sure that it is not PG_active. 

If we call isolate_lru_pages with mode = ISOLATE_BOTH, then it
can return both active and inactive pages and the calling function
has to be able to deal with both kinds of pages.

ISOLATE_BOTH is used when the kernel is trying to defragment memory,
for larger physically contiguous allocations.

-- 
All rights reversed.
