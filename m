Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZEVWr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZEVWr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbZEVWrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:47:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52705 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbZEVWrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:47:51 -0400
Message-ID: <4A172B69.2000709@zytor.com>
Date: Fri, 22 May 2009 15:47:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Xin, Xiaohui" <xiaohui.xin@intel.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "Li, Xin" <xin.li@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com> <4A15DA4E.2090505@goop.org> <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com> <4A1629BA.9070309@goop.org> <C85CEDA13AB1CF4D9D597824A86D2B9005760A9940@PDSMSX501.ccr.corp.intel.com> <4A16D3DF.5000600@zytor.com> <4A172ADE.3010702@goop.org>
In-Reply-To: <4A172ADE.3010702@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> I did a quick experiment to see how many sites this optimisation could 
> actually affect.  Firstly, it does absolutely nothing with frame 
> pointers enabled.  Arranging for no frame pointers is quite tricky, 
> since it means disabling all debugging, tracing and other things.
> 
> With no frame pointers, its about 26 of 5400 indirect calls are 
> immediately followed by ret (not all of those sites are pvops calls).  
> With preempt disabled, this goes up to 45 sites.
> 
> I haven't done any actual runtime tests, but a quick survey of the 
> affected sites shows that only a couple are performance-sensitive; 
> _spin_lock and _spin_lock_irq and _spin_lock_irqsave are the most obvious.
> 

OK, that doesn't seem like a very productive avenue.  Problem still
remains, obviously.

	-hpa

