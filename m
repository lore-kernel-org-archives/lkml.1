Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYH0TCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYH0TCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYH0TCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:02:22 -0400
Received: from gw.goop.org ([64.81.55.164]:38947 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbYH0TCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:02:21 -0400
Message-ID: <48B5A4B0.9050308@goop.org>
Date: Wed, 27 Aug 2008 12:02:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Hugh Dickens <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Definition of x86 _PAGE_SPECIAL and sharing _PAGE_UNUSED1
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_PAGE_SPECIAL is overloading _PAGE_UNUSED1.  Does it really leave
_PAGE_UNUSED1 available for other uses, or does it become an exclusive
user of that flag.  Under what circumstances can they be shared?

arch/x86/mm/pageattr-test.c is now using _PAGE_UNUSED1 as the flag used
to make sure that huge pages are shattered properly (previously it used
_PAGE_GLOBAL).  Is that going to clash with _PAGE_SPECIAL?

In other words, should we drop _PAGE_UNUSED1 altogether, or at least
define how the its different users can coexist?

Am I right in supposing that _PAGE_SPECIAL can only be set on user pages?

(Also, "SPECIAL" is awfully generic.  Was there really no more
descriptive name for this?)

    J
