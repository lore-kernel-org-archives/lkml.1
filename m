Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952Ab0AER1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0AER1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594Ab0AER1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:27:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42940 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0AER1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:27:20 -0500
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: copy_from_user() should not return -EFAULT
From: Andi Kleen <andi@firstfloor.org>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
	<20100104174308.0790757c@infradead.org>
	<20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
	<201001051347.21309.arnd@arndb.de>
	<20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
	<20100105053117.6a7c3377@infradead.org>
	<20100105152215.GD5480@osiris.boeblingen.de.ibm.com>
Date: Tue, 05 Jan 2010 18:27:18 +0100
In-Reply-To: <20100105152215.GD5480@osiris.boeblingen.de.ibm.com> (Heiko Carstens's message of "Tue, 5 Jan 2010 16:22:15 +0100")
Message-ID: <87skakbgy1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens <heiko.carstens@de.ibm.com> writes:

> Subject: [PATCH] sparc: copy_from_user() should not return -EFAULT
>
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> Callers of copy_from_user() expect it to return the number of bytes
> it could not copy. In no case it is supposed to return -EFAULT.
>
> In case of a detected buffer overflow just return the requested
> length. In addition one could think of a memset that would clear
> the size of the target object.

Ouch! I would expect this is likely exploitable, e.g. in mount

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
