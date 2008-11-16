Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYKPHXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYKPHXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYKPHXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:23:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYKPHXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:23:11 -0500
Date: Sun, 16 Nov 2008 08:23:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Philipp Kohlbecher <xt28@gmx.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: alternative identifier for Phoenix BIOS
Message-ID: <20081116072300.GB19646@elte.hu>
References: <491EEDE8.5080508@gmx.de> <491F7D88.7080403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491F7D88.7080403@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Philipp Kohlbecher wrote:
> > My laptop (a Samsung X20) contains a Phoenix BIOS and would 
> > benefit from patch 1e22436eba84edfec9c25e5a25d09062c4f91ca9 (x86: 
> > reserve low 64K on AMI and Phoenix BIOS boxen).
> > 
> > However, according to /sys/class/dmi/id/bios_vendor, the BIOS 
> > identifies its vendor as "Phoenix Technologies LTD" (sans the 
> > comma).

Note that we should do a simpler patch: just change the string to 
"Phoenix Technologies" and that will provide a proper match. (DMI 
matches work on substrings too)

Also, note that you can also force this behavior (and the checking) 
via CONFIG_X86_CHECK_BIOS_CORRUPTION=y - that will enable the 
reservation and a debug check regardless of DMI matches.

> Given that AMI and Phoenix combined is something like 80% of the 
> BIOS market, if not more, it might simply be easier to make it 
> unconditional, or make it a whitelist instead.

The (slim) hope would be for them to address the memory corruptions 
that have been reported. It can affect older Linux versions, etc. So 
we want to print the fact to the syslog, based on the DMI strings from 
the reports.

	Ingo
