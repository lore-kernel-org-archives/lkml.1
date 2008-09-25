Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYIYCec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYIYCec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYIYCeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:34:24 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:3160 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYIYCeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=snfgNtbMhrsjfhW3g6Qzyit05A41tTIZvPSQsltTLnmdLSgR9VAeGHTTYzPGQ4uJOw
         dqVvR2yki/q3IJwmDongf9/QPA9A/63lSOZBZKV0nGpYVJR5s7TDOJptVTnE8TaCqICb
         pA4Azu7f7St+gRfHsC1ZrEe6iknYpX4fnpOhg=
Date: Thu, 25 Sep 2008 10:34:16 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, Alok kataria <alokkataria1@gmail.com>,
       Cristi Magherusan <cristi.magherusan@net.utcluj.ro>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com,
       akataria@vmware.com, Zachary Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925023415.GF21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <1222265424.5708.5.camel@localhost> <20080924142322.GA21049@yantp.cn.ibm.com> <35f686220809240919x631d8f98m5f1d20c2c8e98690@mail.gmail.com> <20080925001521.GB21049@yantp.cn.ibm.com> <48DADAC6.2080500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DADAC6.2080500@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 05:26:46PM -0700, H. Peter Anvin wrote:
> Yan Li wrote:
>> My motivation behind this patch is to serve the MTRR codes to fix a
>> false warning,
>
> It's not a false warning.  It's a true warning.

You can say that warning is justified because it's true that the
MTRR's are all blank in VMware. But that warning is no good to VMware
users since it's by-design all MTRR's are blank. For example, we've
scripts watching the log for lines containing "warning" and "error" on
all production servers. So this warning actually is "false" to VMware
guest users. A KERN_INFO message should be enough here.

We already have a checking to suppress warning on KVM so I think we
should also suppress the warning for VMware guest and Virtual PC.

-- 
Li, Yan
