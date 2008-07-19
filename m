Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYGSR74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYGSR74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYGSR7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:59:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbYGSR7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:59:49 -0400
Date: Sat, 19 Jul 2008 13:59:30 -0400
From: Rik van Riel <riel@redhat.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Nossum <vegard.nossum@gmail.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Message-ID: <20080719135930.3b55381b@bree.surriel.com>
In-Reply-To: <87y73x4w6y.fsf@saeurebad.de>
References: <87y73x4w6y.fsf@saeurebad.de>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 19:31:49 +0200
Johannes Weiner <hannes@saeurebad.de> wrote:

> File pages accessed only once through sequential-read mappings between
> fault and scan time are perfect candidates for reclaim.
> 
> This patch makes page_referenced() ignore these singular references and
> the pages stay on the inactive list where they likely fall victim to the
> next reclaim phase.

Which is exactly what the madvise man page says about pages in
MADV_SEQUENTIAL ranges.  Yay.

       MADV_SEQUENTIAL
              Expect  page  references  in sequential order.  (Hence, pages in
              the given range can be aggressively read ahead, and may be freed
              soon after they are accessed.)

-- 
All rights reversed.
