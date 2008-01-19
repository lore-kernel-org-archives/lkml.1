Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYASTNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYASTNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYASTM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:12:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39768 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYASTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:12:56 -0500
Date: Sat, 19 Jan 2008 20:16:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: ACPI early ioremap problems
Message-ID: <20080119191621.GA3865@one.firstfloor.org>
References: <20080119030843.GA2028@basil.nowhere.org> <20080119150328.GA32370@elte.hu> <20080119152649.GA1375@one.firstfloor.org> <20080119153055.GA12054@elte.hu> <20080119154651.GA1626@one.firstfloor.org> <20080119184543.GA3751@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119184543.GA3751@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, so are you saying that on 64-bit there's in essence no usable 
> ioremap facility between zap_low_mappings() and paging_init()? 
> (early_ioremap() is not usable anymore, and ioremap() is not yet 
> usable.) I guess we'll have to pick up the 32-bit early_ioremap() code 
> for 64-bit as well.

No early_ioremap() should work. Or rather used to work. 

It does map into the kernel mapping which is not zapped. It just broke 
recently.

But it definitely used to work because several users used it before
paging_init() even before the recent PAT changes.

-Andi
