Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZKJOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZKJOnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbZKJOnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:43:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbZKJOnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:43:51 -0500
Message-ID: <4AF97C1A.2080609@redhat.com>
Date: Tue, 10 Nov 2009 16:43:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Rusty Russell <rusty@rustcorp.com.au>, Adam Litke <agl@us.ibm.com>,
       linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>,
       virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the
 balloon driver
References: <1257782838.2835.5.camel@aglitke>	<1257784326.2835.16.camel@aglitke> <200911101312.02650.rusty@rustcorp.com.au> <4AF97A5E.1070801@codemonkey.ws>
In-Reply-To: <4AF97A5E.1070801@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 04:36 PM, Anthony Liguori wrote:
>
>> A stats vq might solve this more cleanly?
>
> actual and target are both really just stats.  Had we implemented 
> those with a vq, I'd be inclined to agree with you but since they're 
> implemented in the config space, it seems natural to extend the config 
> space with other stats.
>

There is in fact a difference; actual and target are very rarely 
updated, while the stats are updated very often.  Using a vq means a 
constant number of exits per batch instead of one exit per statistic.  
If the vq is host-driven, it also allows the host to control the update 
frequency dynamically (i.e. stop polling when there is no memory pressure).

-- 
error compiling committee.c: too many arguments to function

