Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbYAKOOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbYAKOOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYAKOOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:14:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbYAKOOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:14:41 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
To: Abhishek Rai <abhishekrai@google.com>, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, gregkh@suse.de, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       arjan@infradead.org,
       ?missing.closing.'"' in token?"Barnes",
	Jesse <jesse.barnes@intel.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org,
	 ?missing closing '"'.in.token?"Siddha"@vax.1wt.eu,
       Suresh B <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	?missing closing '"' in token?"Barnes", Jesse <jesse.barnes@intel.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, ?missing closing '"' in token?"Siddha"
			^-extraneous tokens in address
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	?missing closing '"' in token?"Barnes", Jesse <jesse.barnes@intel.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, ?missing closing '"' in token?"Siddha"
			^-extraneous tokens in address
Reply-To: 7eggert@gmx.de
Date: Fri, 11 Jan 2008 15:12:16 +0100
References: <9q1CT-82L-3@gated-at.bofh.it> <9q3v2-2Br-3@gated-at.bofh.it> <9qgLE-7ds-21@gated-at.bofh.it> <9qjJx-3wE-9@gated-at.bofh.it> <9qm4D-70Q-1@gated-at.bofh.it> <9CQTt-7cr-27@gated-at.bofh.it> <9KcYS-46E-27@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JDKcK-0003cu-Ps@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/DMXuKMeTEVc/gB7m8nddxPuUztmahDMl5CUg
 V7McaYeXOGJRvfN7U1a1vqqtF6R/Qh2I0+asLEqAg7qsIXgdCR
 IVDu95eHCzG44hANYpkiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Rai <abhishekrai@google.com> wrote:

> Putting metacluster at the end of the block group gives slightly
> inferior sequential read throughput compared to putting it in the
> beginning or the middle, but the difference is very tiny and exists
> only for large files that span multiple block groups.

Just an idea:

What about putting it into the end of the previous block group (except for
the first group, off cause) and starting to read the block group a little
earlier (readahead/~before)? I imagine it might be about as good as placing
it at the beginning while avoiding the fragmentation.

