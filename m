Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbXBZKe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbXBZKe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXBZKe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:34:59 -0500
Received: from smtp.nokia.com ([131.228.20.170]:45952 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbXBZKe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:34:58 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070225054547.GB7941@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
	 <20070220145503.GC3170@thunk.org>
	 <1171984555.3518.5.camel@hades.cambridge.redhat.com>
	 <1171985055.4039.44.camel@sauron>  <20070225054547.GB7941@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Feb 2007 12:28:02 +0200
Message-Id: <1172485682.4039.92.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Feb 2007 10:28:02.0655 (UTC) FILETIME=[CB6ED6F0:01C75990]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070226122413-08588BB0-48A8B7E5/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 05:45 +0000, Christoph Hellwig wrote:
> It's definitively not safe for userspace - packed is not an ISO C thing
> and there's no guarantee userspace compilers understand it.   Also you
> really don't want to use packed in new code, if you really need oddly
> aligned types it's much better to use byte arrays.

Let me express my unsorted points:

1. It is certainly OK in kernel, if it is not OK in user-space, 'make
headers_install' should remove the __attribute__ stuff.

2. I failed to find __atribute__ stuff in ISO C99, so it is not
standard. _BUT_ there are many non-C99 assumptions in kernel anyway. So
"non ISO C" is a weak argument anyway.

3. 
[dedekind@mordor ubi-2.6.git]$ make headers_install
 .... [snip]
[dedekind@mordor include]$ grep -r packed * | wc -l
117

This is the _fact_ of life.

4. Nonetheless, I do not mind at all to remove the "packed" stuff if you
can guarantee that all this compilers on all platforms will use it as
packed. Otherwise we should play safe instead.

Artem.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

