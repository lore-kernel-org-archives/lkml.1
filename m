Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbZEKVNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbZEKVNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZEKVNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:13:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60237 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZEKVNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:13:36 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <20090509143742.GA27663@kroah.com> <20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de> <1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1k54nfv9h.fsf@fess.ebiederm.org>
	<ac3eb2510905111016u1a79defctff3578688ee36f00@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 May 2009 14:13:32 -0700
In-Reply-To: <ac3eb2510905111016u1a79defctff3578688ee36f00@mail.gmail.com> (Kay Sievers's message of "Mon\, 11 May 2009 19\:16\:58 +0200")
Message-ID: <m1fxfbuyv7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, greg@kroah.com, fabio.comolli@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, peterz@infradead.org, alan@lxorguk.ukuu.org.uk, arjan@infradead.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1589]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch 00/13] devtmpfs patches
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Mon, May 11, 2009 at 18:40, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> The goal for kernel compile options is that they do not affect the
>> kernels behavior.  The behavior in devmtmpfs clearly does not match
>> that rule.  The kernel acts very different with it compiled in
>> and with it not compiled in. So that section of the code deserves.
>
> It's the same as with any other option, like the ones that enable
> dynamic minors.

No it's not.

The practical goal is that a distribution can enable essentially every feature
in the kernel and not be forced to use one.

The most similar example I can think of is the dhcp client in the kernel.
Even when compiled in only if you enable it on the command line (aka ip=dhcp)
does it enable and attempt to network boot.

Mouting on /dev might be sane if it was enabled by a kernel command line option.
By default it is wrong.

Dynamic minors is right on that hairy edge.  I'm puzzled know why we
can't have the first N devices use the static assignment and the rest
of the devices use the dynamic minors.

Eric
