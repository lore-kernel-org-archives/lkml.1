Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYCTPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYCTPJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYCTPJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:09:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbYCTPJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:09:08 -0400
Message-ID: <47E27D08.9050809@redhat.com>
Date: Thu, 20 Mar 2008 12:04:40 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ak@suse.de
Subject: Re: [PATCH 45/79] [PATCH] fix apic acking of irqs
References: <12059475744092-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send! -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat <12059477792893-git-send-email-gcosta@redhat.com> <alpine.SOC.1.00.0803201016540.12075@piorun>
In-Reply-To: <alpine.SOC.1.00.0803201016540.12075@piorun>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Wed, 19 Mar 2008, Glauber de Oliveira Costa wrote:
> 
>> EOI is a write-only register. Using write around will have the effect
>> of reading it, which will make all subsequent reads of the ESR register
>> to return an error code. It was unnotices for quite a while because main sources
>> of reading the ESR register where done prior to apic interrupt enabling.
> 
>  Are you sure this actually triggers for APIC chips affected by the 
> erratum in question?  And please note that for them the effect of two 
> consecutive writes will be much more disastrous than setting a bit in the 
> ESR register.
> 
>   Maciej

I'm not _sure_, but I can't find anything in the errata list that states 
otherwise. It would be great that anyone has such a system to test it. 
But with the current conditions, it will break bootup code. In case it 
is really a problem, we'd need to make a special case for that.
