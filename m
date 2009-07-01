Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZGAJnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZGAJnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZGAJmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:42:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49531 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbZGAJmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:42:52 -0400
Message-ID: <4A4B3007.7080303@redhat.com>
Date: Wed, 01 Jul 2009 12:44:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v6 3/4] KVM: Fix races in irqfd using new	eventfd_kref_get
 interface
References: <20090629153627.31959.76947.stgit@dev.haskins.net> <20090629154415.31959.2666.stgit@dev.haskins.net> <20090629161159.GB22029@redhat.com> <4A48F148.5030501@novell.com>
In-Reply-To: <4A48F148.5030501@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 07:52 PM, Gregory Haskins wrote:
>
>>    One idea I had to make it even clearer was to have a shutdown list
>> of irqfds per-kvm, together with the items list, and make work_struct for
>> shutdown global, not per-irqfd.  We can then unconditionally do
>> list_move + schedule_work to shut down an irqfd, and it's safe to do
>> even if it is already on the shutdown list - it just gets moved to tail.
>>
>>      
>
> Hmm..I'm not sure that churn really buys us anything, tho.  Technically
> the "active" bit is redundant with list_del_init()+list_empty() that I
> employed in previous versions.  However, I made it explicit with the
> active bit to be more self-documenting.  IMO, the latest code is pretty
> clear, and the change you are proposing is moving towards a slightly
> trickier variant like I originally had.  I'd say "lets leave this as is".
>    

Could retain self documentation by introducing a helper irqfd_active() 
which does the list_blah() magic.

-- 
error compiling committee.c: too many arguments to function

