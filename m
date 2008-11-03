Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYKCJKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYKCJKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbYKCJJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:09:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188AbYKCJJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:09:51 -0500
Date: Mon, 3 Nov 2008 10:08:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrey Borzenkov <arvidjaar@mail.ru>, Avi Kivity <avi@qumranet.com>
Cc: mingo@redhat.com, avi@qumranet.com, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
Message-ID: <20081103090843.GI11730@elte.hu>
References: <200810312118.45368.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810312118.45368.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrey Borzenkov <arvidjaar@mail.ru> wrote:

> Subject: [PATCH] Use BIOS reboot on Toshiba Portege 4000
> 
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> After commit c7ffa6c26277b403920e2255d10df849bd613380 which defaults
> to reboot via ACPI keyboard is dead on Toshiba Portege 4000 upon reboot.
> Power off is required to revive it again. Add DMI entry to force BIOS
> reboot method as it was before.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

Avi, i expect more boxes to be affected by this bug, and the DMI 
solution just does not scale.

So could we please disable VMX from the emergency-shutdown code 
instead of twiddling with the reboot method?

Something like this might work as well: iff VMX is enabled, we just do 
smp_send_stop() (instead of skipping it) which should take care of 
this.

	Ingo
