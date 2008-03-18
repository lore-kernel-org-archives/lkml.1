Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYCRCZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYCRCZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 22:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYCRCZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 22:25:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbYCRCZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 22:25:26 -0400
Date: Mon, 17 Mar 2008 19:25:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] thermal: fix Kconfig dependencies
In-Reply-To: <200803171459.10656.lenb@kernel.org>
Message-ID: <alpine.LFD.1.00.0803171920320.3020@woody.linux-foundation.org>
References: <20080317095845.GA6500@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803170953210.3020@woody.linux-foundation.org> <20080317184339.GA3754@osiris.boeblingen.de.ibm.com> <200803171459.10656.lenb@kernel.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Mar 2008, Len Brown wrote:
> 
> Similarly, ACPI_THERMAL should not depend on THERMAL,
> instead the code that registers with THERMAL should
> simply depend on if THERMAL is selected or not.
> 
> Also, the "default y" should go.
> 
> I'll tinker with this a bit after lunch.

Hmm.. It looks like the same commit that caused these Kconfig issues is 
also the one that causes the problems with lmsensors (I didn't immediately 
realize that it's the exact same commit).

I think that right now the right thing to do is to just revert it, since 
apparently there won't be a released lmsensors version by the time 2.6.25 
gets released that can handle the new sysfs layout, and that we should 
give this some more time to be resolved.

So I'm inclined to revert commit 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9 
and plan on revisiting this for 2.6.26. I already got an ack for that from 
Jean Delvare, but I thought I'd mention it in this thread too before I 
actually do the final revert.

Any really strong objections?

		Linus
