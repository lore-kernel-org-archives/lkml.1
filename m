Return-Path: <linux-kernel-owner+w=401wt.eu-S1764190AbXJZVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbXJZVnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXJZVnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:43:11 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28210 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbXJZVnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:43:10 -0400
Message-ID: <47225F6C.5000708@ct.jp.nec.com>
Date: Fri, 26 Oct 2007 14:43:08 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com, tglx@linutronix.de
Cc: hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/3] x86: unify crash_32/64.c
References: <47195763.1090803@ct.jp.nec.com> <20071024063434.GC4622@in.ibm.com> <471F72AD.8030902@ct.jp.nec.com> <4720D933.3080703@ct.jp.nec.com>
In-Reply-To: <4720D933.3080703@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm now testing crash on 32bit, but there is an issue before
> applying the patches. My machine stopped at checking 'hlt'
> after kexec, showing below message.
> 
> CPU: Intel(R) Xeon(TM) CPU 3.80GHz stepping 0a
> Checking 'hlt' instruction...
> 
> v2.6.23.1 works fine for 1st kernel.
> I'm investigating it..

I found that the following patch makes my machine stopped.
bfe0c1cc6456bba1f4e3cc1fe29c0ea578ac763a
x86: HPET force enable for ICH5

It means that after applied this patch, HPET is enabled
automatically on 1st kernel and after crash/kexec the 2nd
kernel stopped at checking 'hlt'.

I also tested the latest kernel(2.6.24-rc1-gec3b67c1).
Boot parameter "nohpet" resolves this issue and kdump
works well on 32bit.
So I guess HPET affects this.
But I don't know why 64bit kernel with HPET is OK.

Thanks
Hiroshi Shimamoto
