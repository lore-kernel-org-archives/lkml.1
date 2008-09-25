Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYIYOjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYIYOjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYIYOjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:39:25 -0400
Received: from ag-out-0708.google.com ([72.14.246.241]:26008 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYIYOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TwTiRqFSuMnI1rjVLhTjYWjC3c4+6C7QIw+aDSB8BbIq9BYnZ6yQQ/yrZlJJkhfEuK
         Fysym4Z4brxd7WgRoHGTMIbJBI4SC3HHUm1SsXEErsJfQF9mS37DvTEwXrT/izkWeElk
         tjfsklu4VCHs9ILhRZMHvdbxTO0BgZm7PWEmo=
Date: Thu, 25 Sep 2008 22:38:25 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>, Yan Li <elliot.li.tech@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925143824.GA31760@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <20080925022325.GA14390@kroah.com> <20080925024748.GG21049@yantp.cn.ibm.com> <20080925025550.GA15249@kroah.com> <48DB198C.1090207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DB198C.1090207@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:54:36PM -0700, H. Peter Anvin wrote:
> We pretty much have to, just as we have to work around bugs in, say,  
> AMD's microcode.  We have avoided it so far, but it's gotten to a  
> breaking point, and rather than having ad hoc hacks scattered all over  
> the place I want a centralized test site setting a single global 
> variable.

That sounds great but technically this centralized test can only be
done after dmi_scan_machine(), so it can't help the detection code in
mtrr_trim_uncached_memory() which is ran very early before
dmi_scan_machine(). So I think my patch is still necessary unless we
want to live with the warning message in all VMware guest.

-- 
Li, Yan
