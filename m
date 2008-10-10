Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbYJJTyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbYJJTyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761648AbYJJTyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:54:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37983 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761147AbYJJTyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:54:15 -0400
Date: Fri, 10 Oct 2008 21:53:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Message-ID: <20081010195339.GA509@elte.hu>
References: <20081009190405.13A253CB@kernel> <200810101517.17809.rjw@sisk.pl> <20081010145422.GE11695@elte.hu> <200810102153.45174.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810102153.45174.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > > Surely not ACPI-compliant.
> > 
> > what do you mean?
> 
> The ACPI spec says quite specifically what should be done while 
> entering hibernation and during resume from hibernation.  We're not 
> following that in the current code, but we can (gradually) update the 
> code to become ACPI-compilant in that respect.  However, if we go the 
> checkpointing route, I don't think that will be possible any more.

ah, i see. I did not mean to utilize any ACPI paths but simple powerdown 
or reboot.

If we checkpoint all apps to persistent disk areas (which the checkpoint 
patches in this thread are about), then we can just reboot the kernel 
and forget all its state.

That capability can be used to build a really robust hibernation 
implementation IMO: we could "hibernate/kexec" over between different 
kernel versions transparently. (only a small delay will be noticed by 
the user - if we do it smartly with in-kernel modesetting then not even 
the screen contents will be changed over this.)

	Ingo
