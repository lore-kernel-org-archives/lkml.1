Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbZIBMs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbZIBMs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 08:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZIBMs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 08:48:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbZIBMsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 08:48:55 -0400
Date: Wed, 2 Sep 2009 09:48:39 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] keep guest wallclock in sync with host clock
Message-ID: <20090902124839.GM30340@mothafucka.localdomain>
References: <1251805848-17451-1-git-send-email-glommer@redhat.com> <1251805848-17451-2-git-send-email-glommer@redhat.com> <4A9E5A8B.4060804@redhat.com> <20090902122144.GL30340@mothafucka.localdomain> <4A9E63FA.8040808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9E63FA.8040808@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 03:24:26PM +0300, Avi Kivity wrote:
> On 09/02/2009 03:21 PM, Glauber Costa wrote:
>>
>>>> +static void kvm_sync_wall_clock(struct work_struct *work)
>>>> +{
>>>> +	struct timespec now;
>>>> +
>>>> +	kvm_get_wall_ts(&now);
>>>>
>>>>        
>>> What happens if we schedule here?
>>>      
>> hummm, I guess disabling preemption would be enough to make us safe here?
>>    
>
> You can't prevent host preemption.  You might read kvmclock again and  
> repeat if too much time has passed.
But then you can be scheduled after you did settimeofday, but before reading
kvmclock again. Since we're aiming for periodic adjustments here,
any discrepancies should not last long, so we can maybe live with it.

