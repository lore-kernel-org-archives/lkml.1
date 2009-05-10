Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZEJKCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZEJKCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 06:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZEJKBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 06:01:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50079 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbZEJKBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 06:01:51 -0400
Message-ID: <4A06A59A.2010703@redhat.com>
Date: Sun, 10 May 2009 12:59:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws> <4A01B4CF.3080706@novell.com> <4A03EA83.6040907@redhat.com> <4A044DB5.7050304@novell.com> <4A046519.30604@redhat.com> <4A04802B.9000003@novell.com> <4A048413.4060406@redhat.com> <4A048F2E.3080702@novell.com>
In-Reply-To: <4A048F2E.3080702@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>
>> That only works if the device exposes a pio port, and the hypervisor
>> exposes HC_PIO.  If the device exposes the hypercall, things break
>> once you assign it.
>>     
>
> Well, true.  But normally I would think you would resurface the device
> from G1 to G2 anyway, so any relevant transform would also be reflected
> in the resurfaced device config.  

We do, but the G1 hypervisor cannot be expected to understand the config 
option that exposes the hypercall.

> I suppose if you had a hard
> requirement that, say, even the pci-config space was pass-through, this
> would be a problem.  I am not sure if that is a realistic environment,
> though. 
>   

You must pass through the config space, as some of it is device 
specific.  The hypervisor will trap config space accesses, but unless it 
understands them, it cannot modify them.

-- 
error compiling committee.c: too many arguments to function

