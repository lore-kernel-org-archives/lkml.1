Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZGTVwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZGTVwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZGTVwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:52:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49435 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZGTVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:52:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=dFZ7VJrCMzM201RxfXmuujei8Ah4XPp0MxZe0m8UGIw33rm3wiArPEwJ6JgabFQrS
	LDA74hf6a4jqcsDA45xsA==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org>
	 <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com>
	 <20090714210557.0f983c37@bree.surriel.com>
	 <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
	 <6599ad830907161629p54783716p7246e030b8da00fe@mail.gmail.com>
	 <alpine.DEB.2.00.0907170225570.15373@chino.kir.corp.google.com>
	 <6599ad830907171303v255a0d65t64885d37c41b764a@mail.gmail.com>
	 <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com>
Date: Mon, 20 Jul 2009 14:52:29 -0700
Message-ID: <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 4:12 PM, David Rientjes<rientjes@google.com> wrote:
>
> My patches don't merely address threads that have an oom_adj value of
> OOM_DISABLE while others sharing the same memory do not, they address a
> consistency issue whereas those threads may all share memory but have
> radically different oom_adj values: that means that only the highest
> oom_adj value amongst them is actually used by the oom killer and all
> other oom_adj values set by the user for those threads are wrong.

But these patches change an API that has existed for at least 4 years
(i.e. before git history exists) and the change is known to break some
apps that relied on the existing API. Should there be more
justification than to fix an inconsistency that only you seem to be
claiming is a problem? (Yes, I know it also fixes the OOM killer
livelock, but that could be done without breaking the API).

Paul
