Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbXGKLcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbXGKLcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbXGKLb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:31:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:46126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbXGKLbz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:31:55 -0400
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: nagar@watson.ibm.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Optimize struct task_delay_info
References: <1184138034.3068.51.camel@ymzhang>
From: Andi Kleen <andi@firstfloor.org>
Date: 11 Jul 2007 14:27:11 +0200
In-Reply-To: <1184138034.3068.51.camel@ymzhang>
Message-ID: <p73d4yzyvkw.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
> replace them;
> 2) Delete lock. The change to the protected data has no nested cases.
> In addition, the result is for performance data collection, so it¢s
> unnecessary to add such lock. 

Not sure that's a good idea. People expect their performance counts
to be accurate too. You could possibly use atomics though, but 
when there are multiple counters updated the spinlock will be likely
faster.

-Andi
