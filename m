Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676Ab0ATPBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab0ATPBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122Ab0ATPBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:01:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab0ATPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:01:30 -0500
Date: Wed, 20 Jan 2010 16:58:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: mtosatti@redhat.com, Davide Libenzi <davidel@xmailserver.org>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kvm: fix spurious interrupt with irqfd
Message-ID: <20100120145822.GB3434@redhat.com>
References: <20100113171222.GA19798@redhat.com> <4B5305CA.5070001@redhat.com> <20100119145202.GC28465@redhat.com> <4B570EDD.6000808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B570EDD.6000808@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 04:10:37PM +0200, Avi Kivity wrote:
> On 01/19/2010 04:52 PM, Michael S. Tsirkin wrote:
>> On Sun, Jan 17, 2010 at 02:42:50PM +0200, Avi Kivity wrote:
>>    
>>> On 01/13/2010 07:12 PM, Michael S. Tsirkin wrote:
>>>      
>>>> Deassigning irqfd and assigning back caused spurious interrupt. fix this
>>>> by clearing the counter on deassign.  This is on top of davidel's patch
>>>> which makes clearing eventfd counter from modules possible.
>>>>
>>>>        
>>> Applied both, thanks.
>>>      
>> Hmm, I see this in kvm master.  Avi/Marcelo, since this is a bugfix, can
>> you queue this patchset for 2.6.33 and 2.6.32 stable as well please?
>>    
>
> I'm uncomfortable with pushing Davide's patch into stable and possibly  
> causing regressions with unrelated applications.  Can't a guest live  
> with a spurious interrupt?

Well guests mask/unmask vector on each interrupt, so this will trigger
an irq storm I think.

>  It's not like they're unknown.

Depends on the device really.
In theory, if they trigger at an unfortunate time this could cause
crashes.



-- 
MST
