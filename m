Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZEHK5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZEHK5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZEHK5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:57:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46273 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZEHK5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:57:45 -0400
Date: Fri, 8 May 2009 12:57:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 5/8] xen/i386: make sure initial VGA/ISA mappings are
	not overridden
Message-ID: <20090508105728.GB11596@elte.hu>
References: <1241727902-3176-1-git-send-email-jeremy@goop.org> <1241727902-3176-6-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241727902-3176-6-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> arch/x86/mm/init_32.c overrides the ISA/VGA mappings with direct mappings
> which do not have _PAGE_IOMAP set, thereby making the ISA space inaccessible.
> 
> This patch adds to the existing hack to make sure the 
> pre-constructed ISA mappings are not incorrectly overwritten.
> 
> This makes 32-bit dom0 VGA work properly.

I'm wondering, should we add this fix to .30 as well, is there any 
relevancy beyond dom0?

> Thanks to Gerd Hoffman for pointing this out.

Please add Reported-by lines in such cases. That way not only does 
the reporting get reported prominently, but the tip-bot will Cc: 
Gerd too on the commit notification too. (which will sometimes spur 
further comments - while a commit hidden somewhere might not)

> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Please also add impact-footers to all commits you queue up, if you 
want me to pull your tree directly. I can only guess at the impact 
of this one, is it:

[ Impact: fix dom0-Xen-guest boot crash ]

or:

[ Impact: fix dom0-Xen-guest non-working VGA console ]

?

(Please look at latest tip/master for examples about various impact 
lines, their precise format, and what we try to describe in them and 
how.)

Thanks,

	Ingo
