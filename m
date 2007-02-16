Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXBPLDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXBPLDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 06:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXBPLDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 06:03:12 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:19379 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbXBPLDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 06:03:11 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 11:03:06 +0000
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and
 disableunsupported config options.
From: Keir Fraser <keir@xensource.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       <xen-devel@lists.xensource.com>, Ian Pratt <Ian.Pratt@xensource.com>,
       <virtualization@lists.osdl.org>, Steven Hand <steven.hand@cl.cam.ac.uk>,
       Christian Limpach <Christian.Limpach@xensource.com>,
       <linux-kernel@vger.kernel.org>
Message-ID: <C1FB3FEA.98F7%keir@xensource.com>
Thread-Topic: [patch 14/21] Xen-paravirt: Add XEN config options and
 disableunsupported config options.
Thread-Index: AcdRugj+R6aSPL2tEduvqQAX8io7RQ==
In-Reply-To: <20070216025452.d25e3545.akpm@linux-foundation.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 10:54, "Andrew Morton" <akpm@linux-foundation.org> wrote:

> OK, you're screwed.  I agree that the process freezer is the way out of that
> one.
> 
> Ingo said that he's clocked the freezer at a few milliseconds.  But if it's
> any higher than that it'll need to get sped up once we convert cpu hotplug
> to use it.

A few milliseconds is acceptable. Presumably that is under some stress
workload? What we'd really like is to be able to gang-hotplug CPUs to
amortise the freezer overhead.

This initial patchset does not include save/restore support anyway, so in
fact it would be consistent to have CONFIG_PREEMPT configurable. I'm sure
that we are going to have some nasty bugs to fix up as a result, but we
can't fix them until we find them! Then we can convert our save/restore code
to use the freezer before submitting it for inclusion.

 -- Keir

