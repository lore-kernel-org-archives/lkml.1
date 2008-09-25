Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYIYCsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYIYCsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYIYCsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:48:11 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:5574 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYIYCsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R3GdpDgdFc22MhNm8k4j3rGpT5QrsbvGe+BoK3FB1iliUGX54m1zRbLWqv4A6nY/gr
         QHfXB+9la7BmHQxz4i7jnmBdB3u8m953qBLE6Wq3gOC9KTCM36m1HjWDszHimfcKqGhw
         vb5835CSFp/BZNJW40skFR8v41Rga69MA7krY=
Date: Thu, 25 Sep 2008 10:47:48 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925024748.GG21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <20080925022325.GA14390@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925022325.GA14390@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 07:23:25PM -0700, Greg KH wrote:
> On Wed, Sep 24, 2008 at 08:22:10PM +0800, Yan Li wrote:
> > Detects whether we are running as a VMware guest or not. Detection is
> > based upon DMI vendor string.
> > 
> > It provides a function:
> > int is_vmware_guest(void)
> > that can be used easily to detect if we are running as a VMware guest
> > or not.
> 
> Why do we need to do this within the kernel, what is that going to
> achieve?
> 
> People can do this easily in userspace if they need to detect this, I
> think there's a patch for util-linux-ng adding such a simple utility
> that handles almost all of the known virtualization engines right now.

Hi Greg,

For me this is used in the next patch (for mtrr/main.c) to suppress an
unnecessary warning when running as a VMware guest:
http://lkml.org/lkml/2008/9/24/144

We already have code to suppress warning under KVM so the above patch
suppress warnings for VMware guest also.

H. Peter Anvin and Alok kataria are also proposing we may need a more
general approach for detecting hypervisors that can be used for some
other quirks.

Thanks.


-- 
Li, Yan
