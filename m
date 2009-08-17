Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZHQJVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZHQJVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbZHQJVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:21:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbZHQJVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:21:33 -0400
Date: Mon, 17 Aug 2009 11:20:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       ak@linux.intel.com, tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine
	check code on 32bit
Message-ID: <20090817092047.GB21269@elte.hu>
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A891E17.1090901@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> One possibility is: if the BIOS doesn't clear status in banks, new 
> mce codes will try to log such junks. If the junk is totally junk 
> but can be decoded as a valid log with MISCV or ADDRV bit, and if 
> the cpu try to access register which is not implemented (e.g. 
> IA32_MCi_MISC/ADDR), then such access might cause a general 
> protection exception. (ref. ASDM 3A 15.3.2.3)

btw., that reminds me: mce_rdmsrl() needs to be fixed to use 
rdmsrl_safe() and it should emit a WARN_ONCE() if it ever hits an 
error while trying to access registers.

	Ingo
