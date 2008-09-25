Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYIYD3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYIYD3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 23:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYIYD3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 23:29:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:19403 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYIYD3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 23:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wWI5FLiy47lEjtXef2LFHkGqEj2wruieegZ6OKV2QsMG9qHBgzSHQQFSK7ctJBT693
         nlLemaljREmJ3T9gG+A5JoS5La8G3pibJNYZQ9ADE7zgphSXrilH3XuHrfV1GG0f1uKQ
         lkL98OhduhhKi9JE6ObmPwbk35sHhQxuoVpNw=
Date: Thu, 25 Sep 2008 11:29:27 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925032927.GK21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <20080925022325.GA14390@kroah.com> <20080925024748.GG21049@yantp.cn.ibm.com> <20080925025550.GA15249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925025550.GA15249@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 07:55:50PM -0700, Greg KH wrote:
> > Hi Greg,
> > 
> > For me this is used in the next patch (for mtrr/main.c) to suppress an
> > unnecessary warning when running as a VMware guest:
> > http://lkml.org/lkml/2008/9/24/144
> 
> But that has been stated it's a vmware bug, not a kernel bug :)

I think it's a common practice for VM to blank the MTRRs rather than a
bug. Many hypervisors (KVM, VMware, Virtual PC) are doing this since
long before. Therefore I think issuing a warning here complaining
about blank MTRRs are no use to VMware's users.

> > We already have code to suppress warning under KVM so the above patch
> > suppress warnings for VMware guest also.
> > 
> > H. Peter Anvin and Alok kataria are also proposing we may need a more
> > general approach for detecting hypervisors that can be used for some
> > other quirks.
> 
> Well, having a config option like this isn't the way to go as it will be
> forced on for all distros and users anyway.

My idea is that this should be included in all general purpose kernels
or the vendors may have to cope with flood questions about boot time
warnings when using under VMware/KVM/Virtual PC.  It's configurable so
good for vendors who wish to provide different kernels for using with
real-machines and VMs.

> A simple cpuid test is the easier way to do this, that's what the
> userspace tools do, if it's really needed in the kernel.  But hopefully,
> such things shouldn't be needed within the kernel as it's not Linux's
> fault that the hypervisor has bugs in it :)

A simple CPUID test is good but can't be used for VMware guest since
they just use underlying CPUID, so nothing special here can be
checked. That's why I'm using DMI.

> We wouldn't be wanting to work around bugs in Microsoft's hypervisor,
> would we?


-- 
Li, Yan
