Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZKJO6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZKJO6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZKJO6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:58:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46429 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZKJO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:58:35 -0500
Message-ID: <4AF97F93.2080707@us.ibm.com>
Date: Tue, 10 Nov 2009 08:58:27 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Rusty Russell <rusty@rustcorp.com.au>, agl@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the
 balloon driver
References: <1257782838.2835.5.camel@aglitke> <1257784326.2835.16.camel@aglitke>	<200911101312.02650.rusty@rustcorp.com.au> <4AF97A5E.1070801@codemonkey.ws> <4AF97C1A.2080609@redhat.com>
In-Reply-To: <4AF97C1A.2080609@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 11/10/2009 04:36 PM, Anthony Liguori wrote:
>>
>>> A stats vq might solve this more cleanly?
>>
>> actual and target are both really just stats.  Had we implemented 
>> those with a vq, I'd be inclined to agree with you but since they're 
>> implemented in the config space, it seems natural to extend the 
>> config space with other stats.
>>
>
> There is in fact a difference; actual and target are very rarely 
> updated, while the stats are updated very often.  Using a vq means a 
> constant number of exits per batch instead of one exit per statistic.  
> If the vq is host-driven, it also allows the host to control the 
> update frequency dynamically (i.e. stop polling when there is no 
> memory pressure).

I'm not terribly opposed to using a vq for this.  I would expect the 
stat update interval to be rather long (10s probably) but a vq works 
just as well.

-- 
Regards,

Anthony Liguori

