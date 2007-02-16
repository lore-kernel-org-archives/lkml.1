Return-Path: <linux-kernel-owner+w=401wt.eu-S1946171AbXBPSHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946171AbXBPSHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946174AbXBPSHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:07:42 -0500
Received: from gw.goop.org ([64.81.55.164]:39594 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946171AbXBPSHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:07:41 -0500
Message-ID: <45D5F2EC.5000402@goop.org>
Date: Fri, 16 Feb 2007 10:07:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> So I propose we remove all assumptions from the code that we actually
> have an array of irqs.  That will allow for irq_desc to be dynamically
> allocated instead of statically allocated saving memory and reducing
> kernel complexity.
>   

Sounds good to me.  In Xen we have 1024 event channels which we need to
map down into a smaller irq.  Aside from the complexity of maintaining a
mapping table, that's not a huge issue for now, but when we start
exposing pci devices to guests it all becomes more complex.  The ideal
for us is to simply use event channel == irq, which this would allow.

    J
