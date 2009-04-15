Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbZDOLxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbZDOLxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZDOLxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:53:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:18903 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZDOLxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NJflGDYyjLrB41e9jM3kKQj6h6DCq84Z3n5I/GoXfSmWalKCKqfDwMJzsgcz8AVetP
         cAj2iAPQeuxXF8paEjq1Lp9y/pepB2F37aJ2UsWKVxQqj9coNeGzYHgQULgWly3b3+bt
         h4HjOw1g6fBWzqO1qQC0L6+Y53rrYN41W6OdU=
MIME-Version: 1.0
In-Reply-To: <20090415114154.GI9809@random.random>
References: <20090414143252.GE28265@random.random>
	 <200904150042.15653.nickpiggin@yahoo.com.au>
	 <20090415165431.AC4C.A69D9226@jp.fujitsu.com>
	 <20090415104615.GG9809@random.random>
	 <2f11576a0904150439k6e828307ja97b6729650bcb94@mail.gmail.com>
	 <20090415114154.GI9809@random.random>
Date: Wed, 15 Apr 2009 20:53:11 +0900
X-Google-Sender-Auth: 3810b902e2606d17
Message-ID: <2f11576a0904150453g4332e0d5h5bcad97fac7af24@mail.gmail.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Jeff Moyer <jmoyer@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Can we assume mmu_notifier is only used by kvm now?
>> if not, we need to make new notifier.
>
> KVM is no fundamentally different from other users in this respect, so
> I don't see why need a new notifier. If it works for others it'll work
> for KVM and the other way around is true too.
>
> mmu notifier users can or cannot take a page pin. KVM does. GRU
> doesn't. XPMEM does. All of them releases any pin after
> mmu_notifier_invalidate_page. All that is important is to run
> mmu_notifier_invalidate_page _after_ the ptep_clear_young_notify, so
> that we don't nuke secondary mappings on the pages unless we really go
> to nuke the pte.

Thank you kindful explain. I understand it :)
