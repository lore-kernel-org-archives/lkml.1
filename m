Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbXFRIOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbXFRIOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbXFRIN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:13:57 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:45358 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbXFRINz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:13:55 -0400
Subject: Re: [patch] use __asm__ rather than asm in asm-s390/ptrace.h
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20070618073605.GA3580@osiris.boeblingen.de.ibm.com>
References: <200706180223.07122.vapier@gentoo.org>
	 <20070618073605.GA3580@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 18 Jun 2007 10:15:18 +0200
Message-Id: <1182154518.3335.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 09:36 +0200, Heiko Carstens wrote:
> Hmm.. spka is a sort of priviledged instruction and shouldn't be
> user space visible.
> I will move it so it's under #ifdef __KERNEL__.

Yes, I think this is better. On a side node, why did we add psw_set_key
to ptrace.h? processor.h would have made more sense, no? It sets the key
in the psw, it is not usable in userspace and ptrace doesn't provide an
interface for reading/writing to the psw key. So a patch that moves the
inline to processor.h alongside __load_psw and __load_psw_mask would be
my solution.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


