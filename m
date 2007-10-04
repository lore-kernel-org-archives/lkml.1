Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbXJDLmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbXJDLmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760996AbXJDLfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:35:00 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:35524 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760991AbXJDLe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:34:58 -0400
X-Trace: 613277508-mk-filter-4.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.76.66
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAL1qBEdRAUxC/2dsb2JhbACBWQ
Message-ID: <54609.217.150.108.178.1191497676.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20071004100151.GA17628@linux-sh.org>
References: <1191359367.17654.24.camel@localhost.localdomain>
    <20071003061805.GA8851@linux-sh.org>
    <63320.217.150.108.178.1191426097.squirrel@newgolddream.dyndns.info>
    <20071004100151.GA17628@linux-sh.org>
Date: Thu, 4 Oct 2007 12:34:36 +0100 (BST)
Subject: Re: [PATCH] Fix SH DMAC code to handle PVR2 cascade
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Adrian McMenamin" <adrian@newgolddream.dyndns.info>,
       "linux-sh" <linuxsh-dev@lists.sourceforge.net>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, October 4, 2007 11:01 am, Paul Mundt wrote:
> So for PVR2 cascade, what does the CHCR value work out to? Both
> CHCR_TS_MASK and CHCR_TS_SHIFT haven't changed for SH7750, so this
> suggests that either the CHCR value is just wrong or we've had a
> long-standing bug with the CHCR.TS mask.
>
> Either way, we are not going to hardcode a ts_shift value when the CHCR
> has all of the information encoded in it!
>

There *is* a long standing bug in CHCR_TS_MASK. It is meant to mask out
all but bits 6:4 but in fact only masks bits 5 and 4. If it is set to 0x70
and not 0x30 this should work - though as usual I cannot make a patch to
check this out at the moment.
