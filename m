Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZFHKwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZFHKwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZFHKwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:52:06 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49085 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZFHKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nCQLtJKBLyw993C0hNlxWdqDyvxl1EBgdalXsawHdHlfUkqPtIw9jdjYz5SPzNRUdS
         0yBeXivxsWXlHvGwlNQvVTKEYOfoBQ14BEzT8BZQK7ibvH/lZR9/bjtDDoej8BV37coe
         NvWWo1LOLMhJ2DyJF/onhei7B+QC43Dq3udts=
MIME-Version: 1.0
In-Reply-To: <20090608101739.GA15377@csn.ul.ie>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
Date: Mon, 8 Jun 2009 13:52:05 +0300
X-Google-Sender-Auth: fab19ad64e688f19
Message-ID: <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 1:17 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> Pekka, assuming the request size is 800 bytes, and SLUB is using order-1
> pages for allocations of that size, what happened order-1 allocations
> falling back to order-0 allocations as necessary. That logic exists,
> right? If so, could it be broken?

That logic is in allocate_slab() and if the higher order allocation
fails, we fall-back to struct kmem_cache ->min order. That in turn is
set up in calculate_sizes() to get_order(size) so it seems pretty
unlikely to me the allocation is 800 bytes. Of course, I could be
missing something here and there's a bug in oo_make() or oo_order().
Hmm.

                        Pekka
