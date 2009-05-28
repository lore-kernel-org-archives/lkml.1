Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbZE1Tp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbZE1Tp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZE1TpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:45:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:60334 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbZE1TpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:45:21 -0400
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090528125042.28c2676f@lxorguk.ukuu.org.uk>
References: <20090520183045.GB10547@oblivion.subreption.com>
	 <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu>
	 <20090522113809.GB13971@oblivion.subreption.com>
	 <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com>
	 <20090527223421.GA9503@elte.hu>
	 <20090528072702.796622b6@lxorguk.ukuu.org.uk>
	 <20090528090836.GB6715@elte.hu>
	 <20090528125042.28c2676f@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 28 May 2009 21:44:54 +0200
Message-Id: <1243539894.6645.85.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 12:50 +0100, Alan Cox wrote:
> The performance cost of such a security action are NIL when the feature
> is disabled. So the performance cost in the general case is irrelevant.

Not really, much of the code posted in this thread has the form:

int sanitize_all_mem; /* note the lack of __read_mostly */

void some_existing_function()
{
	if (sanitize_all_mem) { /* extra branch */
		/* do stuff */
	}
}

void sanitize_obj(void *obj)
{
	if (!sanitize_all_mem) /* extra branch */
		return;

	/* do stuff */
}


void another_existing_function()
{
	sanitize_obj(obj); /* extra call */
}

That doesn't equal NIL, that equals extra function calls and branches.

