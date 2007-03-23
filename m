Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbXCWSYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbXCWSYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXCWSYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:24:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbXCWSYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:24:06 -0400
Date: Fri, 23 Mar 2007 14:22:48 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: "Stone, Joshua I" <joshua.i.stone@intel.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, hch@infradead.org
Subject: Re: [RFC][Patch 1/4] kprobe fast unregistration
Message-ID: <20070323182248.GA32364@redhat.com>
References: <20070323180527.GA13728@bambi.jf.intel.com> <16D5B9AB904B0B46B22A27002EE3A8C82793BB@scsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16D5B9AB904B0B46B22A27002EE3A8C82793BB@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

Keshavamurthy, Anil S wrote:
> I agree with Christoph that the interface is horrible and error prone.

Really?  What possible problems can occur?  The worst that occurs to
me is that if someone forgets to call the commit function, the kprobes
will still be disabled, but memory won't be recycled for a while.  Is
this really so bad, considering that a kprobe_unregister is to imply a
commit?  Maybe if kprobe_register can also implied a commit, we can
bound the conceivable memory leak.

Would it be possible to allay even that concern with an automated
deferred/periodic commit?

- FChE
