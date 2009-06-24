Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZFXR6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZFXR6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbZFXR6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:58:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50582 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZFXR6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:58:14 -0400
Message-ID: <4A426825.80905@cs.helsinki.fi>
Date: Wed, 24 Jun 2009 20:53:41 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
References: <20090624080753.4f677847@infradead.org>	<20090624094622.d0b0fd82.akpm@linux-foundation.org>	<84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org>
In-Reply-To: <20090624105517.904f93da.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> On Wed, 24 Jun 2009 19:55:24 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
>> On Wed, Jun 24, 2009 at 7:46 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>>> Well yes. __Using GFP_NOFAIL on a higher-order allocation is bad. __This
>>> patch is there to find, name, shame, blame and hopefully fix callers.
>>>
>>> A fix for cxgb3 is in the works. __slub's design is a big problem.
>>>
>>> But we'll probably have to revert it for 2.6.31 :(
>> How is SLUB's design a problem here? Can't we just clear GFP_NOFAIL
>> from the higher order allocation and thus force GFP_NOFAIL allocations
>> to use the minimum required order?
> 
> That could then lead to the __GFP_NOFAIL allocation attempt returning
> NULL.  But the callers cannot handle that and probably don't even test
> for it - this is why they used __GFP_NOFAIL.

No, the fallback allocation would still use __GFP_NOFAIL so the 
semantics are preserved.

			Pekka
