Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXLSNlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXLSNlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXLSNlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:41:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbXLSNlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:41:12 -0500
Date: Wed, 19 Dec 2007 08:40:58 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com
Subject: Re: [patch 10/20] SEQ replacement for anonymous pages
Message-ID: <20071219084058.6ae3c531@bree.surriel.com>
In-Reply-To: <20071219140904.9858.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20071218211539.250334036@redhat.com>
	<20071218211549.536791435@redhat.com>
	<20071219140904.9858.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 14:17:53 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Rik-san,
> 
> > To keep the maximum amount of necessary work reasonable, we scale the
> > active to inactive ratio with the size of memory, using the formula
> > active:inactive ratio = sqrt(memory in GB * 10).

> why do you think best formula is sqrt(GB*10)?
> please tell me if you don't mind.

On a 1GB system, this leads to a ratio of 3 active anon
pages to 1 inactive anon page, and a maximum inactive
anon list size of 250MB.
 
On a 1TB system, this leads to a ratio of 100 active anon
pages to 1 inactive anon page, and a maximum inactive
anon list size of 10GB.

The numbers in-between looked reasonable :)

Basically the requirement is that the inactive anon list 
is large enough that pages get a chance to be referenced
again, but small enough that the maximum amount of work
the VM needs to do is bounded to something reasonable.

> and i have a bit worry to it works well or not on small systems.
> because it is indicate 1:1 ratio on less than 100MB memory system.
> Do you think this viewpoint?

A 1:1 ratio simply means that the inactive anon list is
the same size as the active anon list. Page replacement
should still work fine that way.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
