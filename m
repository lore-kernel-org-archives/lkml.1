Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYIRUw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYIRUw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 16:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYIRUwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 16:52:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7211 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753482AbYIRUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 16:52:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=K5M7mocjk1AzuQOexo3eWyVsbbsbNAAzhQAamM8cgnyzOioMZCI2QuK4ZBWhUNaX5
	xPuniGnbxFFQvG/acBt0Q==
Message-ID: <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>
Date: Thu, 18 Sep 2008 13:52:04 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Populating multiple ptes at fault time
Cc: "Christoph Lameter" <cl@linux-foundation.org>,
       "Chris Snook" <csnook@redhat.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48D2A392.6010308@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D142B2.3040607@goop.org> <48D1625C.7000309@redhat.com>
	 <48D17A93.4000803@goop.org> <48D29AFB.5070409@linux-foundation.org>
	 <48D2A392.6010308@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Thanks, that was exactly what I was hoping to see.  I didn't see any
> definitive statements against the patch set, other than a concern that
> it could make things worse.  Was the upshot that no consensus was
> reached about how to detect when its beneficial to preallocate anonymous
> pages?
>
> Martin, in that thread you mentioned that you had tried pre-populating
> file-backed mappings as well, but "Mmmm ... we tried doing this before
> for filebacked pages by sniffing the
> pagecache, but it crippled forky workloads (like kernel compile) with the
> extra cost in zap_pte_range, etc. ".
>
> Could you describe, or have a pointer to, what you tried and how it
> turned out?

Don't have the patches still, but it was fairly simple - just faulted in
the next 3 pages whenever we took a fault, if the pages were already
in pagecache. I would have thought that was pretty lightweight and
non-invasive, but turns out it slowed things down.

> Did you end up populating so many (unused) ptes that
> zap_pte_range needed to do lots more work?

Yup, basically you're assuming good locality of reference, but it turns
out that (as davej would say) "userspace sucks".
