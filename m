Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbZDHL73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbZDHL73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764237AbZDHLiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:38:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764886AbZDHLiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:38:23 -0400
Date: Wed, 8 Apr 2009 13:40:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [1/4] x86: MCE: Make polling timer interval per CPU
Message-ID: <20090408114038.GB14687@one.firstfloor.org>
References: <20090407506.675031434@firstfloor.org> <20090407150654.071D21D046E@basil.firstfloor.org> <49DC1D7E.4010802@jp.fujitsu.com> <877i1va0j3.fsf@basil.nowhere.org> <49DC8AE5.8010005@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DC8AE5.8010005@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 08:30:45PM +0900, Hidetoshi Seto wrote:
> Andi Kleen wrote:
> >>> +	if (!*n)
> >>> +		*n = check_interval * HZ;
> >>> +	if (!*n)
> >>>  		return;
> > 
> > The !*n will return for check_interval == 0 because 0*HZ is still 0 so it should be 
> > equivalent. Did I miss something?
> 
> At First, *n is 0 on boot.
> And then soon it will be initialized to non-zero (check_interval * HZ)
> by the first if-statement.
> 
> After that if check_interval is changed via sysfs while *n is non-zero,
> which if-statement runs?

Ok got your point now. The first if (!*n) needs to be dropped indeed.
Will respin that patch.

Thanks.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
