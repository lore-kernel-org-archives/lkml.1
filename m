Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZFBGmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZFBGmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZFBGl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:41:56 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64050 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZFBGlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZdbTRfiKnw37JMxg0v34b05JYgWKHiafZ3u1fILbUsNRok7pXMrwPRDM+d/6wWaKxP
         X7Vs9IqkZ0OiF6cvRCvn//kO3Sk7A/wkboAq5ozu47KbBdEqUmgUSpYoPIwVnqcLF5im
         i27n2mMXQ7ebZO+Oa9KcUhZOAdGddqHWiNxr0=
MIME-Version: 1.0
In-Reply-To: <20090602062738.GA31556@wotan.suse.de>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com>
	 <20090601225602.3482cd0d.akpm@linux-foundation.org>
	 <20090602062738.GA31556@wotan.suse.de>
Date: Tue, 2 Jun 2009 09:41:56 +0300
X-Google-Sender-Auth: 28e1b619eb7df395
Message-ID: <84144f020906012341k42530236x823c8393b5e65502@mail.gmail.com>
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Mon, Jun 01, 2009 at 10:56:02PM -0700, Andrew Morton wrote:
>> Do we know of any callsites which do greater-than-order-0 allocations
>> with GFP_NOFAIL?  If so, we should fix them.

On Tue, Jun 2, 2009 at 9:27 AM, Nick Piggin <npiggin@suse.de> wrote:
> Yeah, we have GFP_NOFAIL going to the slab allocator, so all bets are
> off in regard to the order.

SLUB is supports variable order allocations so we can certainly do
GFP_NOFAIL special casing there for < PAGE_SIZE allocations to enforce
zero order allocation for those. I suspect we could do something
similar in SLQB too?

                        Pekka
