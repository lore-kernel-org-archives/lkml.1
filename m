Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbYCVDyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbYCVDyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbYCVDyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:54:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYCVDye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:54:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 handle_vm86_trap cleanup
In-Reply-To: Ingo Molnar's message of  Friday, 21 March 2008 11:39:46 +0100 <20080321103946.GO20420@elte.hu>
References: <20080317092108.EC6C626F995@magilla.localdomain>
	<20080321103946.GO20420@elte.hu>
Emacs: because idle RAM is the Devil's playground.
Message-Id: <20080322035357.4B43326F992@magilla.localdomain>
Date: Fri, 21 Mar 2008 20:53:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> for the record, this also changes semantics, because previously we'd 
> permanently unblock SIGTRAP (most certainly as a hack, to be able to do 
> the send_sig()), while now we use force_sig() which just ignores the 
> blocked mask. (and i agree with your fix of course)

That's not so.  force_sig_info (called by force_sig) removes the signal
from the blocked set too.  That is the only way to get the signal ever to
be dequeued.


Thanks,
Roland
