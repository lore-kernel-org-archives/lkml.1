Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbXGLIiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbXGLIiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbXGLIiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:38:09 -0400
Received: from mga05.intel.com ([192.55.52.89]:61197 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754673AbXGLIiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:38:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,531,1175497200"; 
   d="scan'208";a="267353497"
Subject: Re: [PATCH] Optimize struct task_delay_info
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: nagar@watson.ibm.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <p73d4yzyvkw.fsf@bingen.suse.de>
References: <1184138034.3068.51.camel@ymzhang>
	 <p73d4yzyvkw.fsf@bingen.suse.de>
Content-Type: text/plain; charset=utf-8
Date: Thu, 12 Jul 2007 16:37:23 +0800
Message-Id: <1184229443.3068.55.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 14:27 +0200, Andi Kleen wrote:
> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
> > replace them;
> > 2) Delete lock. The change to the protected data has no nested cases.
> > In addition, the result is for performance data collection, so it’s
> > unnecessary to add such lock. 
> 
> Not sure that's a good idea. People expect their performance counts
> to be accurate too. You could possibly use atomics though, but 
> when there are multiple counters updated the spinlock will be likely
> faster.
Accurancy here has 2 meanings.
1) From data update point of view. The data is correct because only the
process itself updates them and there is no nested update.
2) If the reader could get the correct data when the process updates the data. It
might be an issue. But the issue is not important. Mostly, the application tool
reads the data in an interval.

Yanmin
