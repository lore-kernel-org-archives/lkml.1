Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565Ab0ATPNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0ATPNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127Ab0ATPM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:12:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0ATPM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:12:58 -0500
Date: Wed, 20 Jan 2010 17:09:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: mtosatti@redhat.com, Davide Libenzi <davidel@xmailserver.org>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kvm: fix spurious interrupt with irqfd
Message-ID: <20100120150950.GD3434@redhat.com>
References: <20100113171222.GA19798@redhat.com> <4B5305CA.5070001@redhat.com> <20100119145202.GC28465@redhat.com> <4B570EDD.6000808@redhat.com> <20100120145822.GB3434@redhat.com> <4B571CAC.9000902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B571CAC.9000902@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 05:09:32PM +0200, Avi Kivity wrote:
> On 01/20/2010 04:58 PM, Michael S. Tsirkin wrote:
>>
>>> I'm uncomfortable with pushing Davide's patch into stable and possibly
>>> causing regressions with unrelated applications.  Can't a guest live
>>> with a spurious interrupt?
>>>      
>> Well guests mask/unmask vector on each interrupt, so this will trigger
>> an irq storm I think.
>>
>>    
>>>   It's not like they're unknown.
>>>      
>> Depends on the device really.
>> In theory, if they trigger at an unfortunate time this could cause
>> crashes.
>>
>>    
>
> I'd like confirmation on both of these before I push things to stable.

I have observed the interrupt storm. We end up with interrupt being
disabled. Crash is a theoretical issue.

-- 
MST
