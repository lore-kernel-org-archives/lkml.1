Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbZE0HWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbZE0HWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760982AbZE0HSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:18:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46515 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760950AbZE0HSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:18:09 -0400
Date: Wed, 27 May 2009 09:24:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 19/31] x86: MCE: Default to panic timeout for machine checks v2
Message-ID: <20090527072445.GS846@one.firstfloor.org>
References: <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com> <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com> <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com> <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com> <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com> <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com> <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com> <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com> <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com> <4A1CC20B.1020907@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1CC20B.1020907@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:31:07PM +0900, Hidetoshi Seto wrote:
> I suppose the original intention is overwrite the panic_timeout 0 to 30.

Yes. 

> > @@ -1100,6 +1105,8 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
> >  	}
> >  	if (monarch_timeout < 0)
> >  		monarch_timeout = 0;
> > +	if (mce_bootlog != 0)
> > +		mce_panic_timeout = 30;
> >  }
> >  
> >  static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
> 
> It seems it doesn't work.

Okay fair point. I applied your earlier review suggestion literally yes
that was not correct. I changed it in my patchkit to handle the 0 case too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
