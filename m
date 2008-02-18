Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYBRMb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYBRMb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbYBRMbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:31:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:55071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbYBRMbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:31:49 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
From: Andi Kleen <andi@firstfloor.org>
References: <200802171025.30590.elendil@planet.nl>
	<20080217124650.576990ce@laptopd505.fenrus.org>
Date: Mon, 18 Feb 2008 13:31:48 +0100
In-Reply-To: <20080217124650.576990ce@laptopd505.fenrus.org> (Arjan van de Ven's message of "Sun\, 17 Feb 2008 12\:46\:50 -0800")
Message-ID: <p73mypyxx6z.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> the initial plan was for a depreciation period. Sadly it was untenable since the API
> was changing entirely to fix bugs and add a really important feature
> (the ability to clflush the exact range rather than wbinvd'ing the caches of all cpus in the system), 

Just for the record: I posted full patches to implement clflush
support some time ago without changing any exported API. So your
claims that changing the API was needed to implement CLFLUSH are not
correct.

Also I believe some assumptions behind the new API are faulty (in
particular that the caller doesn't fully own the to be changed pages)
and make it actually impossible to implement the cache attribute PTE
changing operation fully correct according to the Intel x86 manual
(which requires temporary unmap)

-Andi
