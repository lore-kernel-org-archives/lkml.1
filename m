Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbZFIGnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbZFIGnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbZFIGm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:42:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60099 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289AbZFIGm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:42:56 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com,
       tj@kernel.org, adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk,
       gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org,
       hch@infradead.org
References: <m1skkf761y.fsf@fess.ebiederm.org>
	<m1oct739xu.fsf@fess.ebiederm.org>
	<20090606080334.GA15204@ZenIV.linux.org.uk>
	<E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu>
	<20090608162913.GL8633@ZenIV.linux.org.uk>
	<E1MDhxh-0004nz-Qm@pomaz-ex.szeredi.hu>
	<20090608175018.GM8633@ZenIV.linux.org.uk>
	<alpine.LFD.2.01.0906081100000.6847@localhost.localdomain>
	<20090608185041.GN8633@ZenIV.linux.org.uk>
	<alpine.LFD.2.01.0906081217340.6847@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Jun 2009 23:42:53 -0700
In-Reply-To: <alpine.LFD.2.01.0906081217340.6847@localhost.localdomain> (Linus Torvalds's message of "Mon\, 8 Jun 2009 12\:18\:41 -0700 \(PDT\)")
Message-ID: <m1ocsxykk2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 8 Jun 2009, Al Viro wrote:
>> 
>> Sure, even though I'm not at all certain that copy_from_user() is that easy.
>> We can make locking current->mm in there interruptible, all right, but that's
>> only a part of the answer - even aside of the allocations, we'd need vma
>> ->fault() interruptible as well, which leads to interruptible instances of
>> ->readpage(), with all the fun _that_ would be.
>
> We already have all that - the NFS people wanted it.
>
> More importantly, you don't actually need to interrupt readpage itself - 
> you just need to stop _waiting_ on it. So in your fault handler, just stop 
> waiting, and instead just return FAULT_RETRY or whatever.

That sounds doable.  Has that code been merged yet?

I took a quick look and it didn't see anyone breaking out of page fault with a
signal or code to really handle that.

Eric
