Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYJ2HRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYJ2HRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYJ2HRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:17:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:1164 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYJ2HRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LikYLJ5FzAWKlwuuKPGF0x7wkW8ntvi4aLvtN+qWQxseY6ZhRan0n1cTRiAbvHuY8+
         wjaS0S40rJcxYpFVNDrQOSbPAr3S3ecNWPy9wiSjTEXFfzQHLkE5w30KZuRLcXRihkyB
         5lQ+t/SkY/IOFtkDl12qsAx9ZEeIhf+SVYAJE=
Message-ID: <2f11576a0810290017g310e4469gd27aa857866849bd@mail.gmail.com>
Date: Wed, 29 Oct 2008 16:17:19 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       heiko.carstens@de.ibm.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, linux-mm@kvack.org
In-Reply-To: <1225229366.6343.74.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com>
	 <2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com>
	 <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081027145509.ebffcf0e.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0810280914010.15939@quilx.com>
	 <20081028134536.9a7a5351.akpm@linux-foundation.org>
	 <1225229366.6343.74.camel@lts-notebook>
X-Google-Sender-Auth: 0d1696d124dc47ec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe that we still  have the lru_drain_all() called from the fault
> path [with mmap_sem held] in clear_page_mlock().  We call
> clear_page_mlock() on COW of an mlocked page in a VM_LOCKED vma to
> ensure that we don't end up with an mlocked page in some other task's
> non-VM_LOCKED vma where we'd then fail to munlock it later.  During
> development testing, Rik encountered scenarios where a page would
> encounter a COW fault while it was still making its way to the LRU via
> the pagevecs.  So, he added the 'drain_all() and that seemed to avoid
> this scenario.

Agreed.


> Now, in the current upstream version of the unevictable mlocked pages
> patches, we just count any mlocked pages [vmstat] that make their way to
> free*page() instead of BUGging out, as we were doing earlier during
> development.  So, maybe we can drop the lru_drain_add()s in the
> unevictable mlocked pages work and live with the occasional freed
> mlocked page, or mlocked page on the active/inactive lists to be dealt
> with by vmscan.

hm, okey.
maybe, I was wrong.

I'll make "dropping lru_add_drain_all()" patch soon.
I expect I need few days.
  make the patch:                  1 day
  confirm by stress workload:  2-3 days

because rik's original problem only happend on heavy wokload, I think.
