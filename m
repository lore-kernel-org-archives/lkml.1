Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYHNPID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYHNPID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYHNPHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:07:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYHNPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:07:41 -0400
Message-ID: <48A449F9.8010903@linux-foundation.org>
Date: Thu, 14 Aug 2008 10:06:33 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48986AC6.5030406@linux-foundation.org> <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48A2DD2C.3090602@linux-foundation.org> <48A3DBAC.6010109@cs.helsinki.fi>
In-Reply-To: <48A3DBAC.6010109@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
>
> This patch hard locks  on my 2-way 64-bit x86 machine (sysrq doesn't 
> respond) when I run hackbench.
At that point we take the listlock and then the slab lock which is a 
lock inversion if we do not use a trylock here. Crap.

Hmmm.. The code already goes to the next slab if an earlier one is 
already locked. So I do not see how the large partial lists could be 
generated.


