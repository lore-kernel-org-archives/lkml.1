Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZJHQjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZJHQjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZJHQjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652AbZJHQjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:39:20 -0400
Message-ID: <4ACE1598.6050200@redhat.com>
Date: Thu, 08 Oct 2009 18:38:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] KVM: SVM: Notify nested hypervisor of lost event
 injections
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com> <1254996199-17667-2-git-send-email-joerg.roedel@amd.com> <4ACE0F6C.3060103@redhat.com> <20091008162222.GG14073@amd.com> <4ACE127A.6040304@redhat.com> <20091008163234.GJ14073@amd.com>
In-Reply-To: <20091008163234.GJ14073@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 06:32 PM, Joerg Roedel wrote:
> No. The L1 guest needs to execute VMRUN with an interrupt to inject to
> the L2 guest with event_inj. On that VMRUN instruction emulation an
> interrupt becomes pending which causes an immediate #vmexit from L2 to
> L2 again without even entering the L2 guest. The bug was that in this
> case the event which the L1 tried to inject in the L2 was lost because
> it was not copied to exit_int_info.
>    

(from L1 to L0?)

Wow.  Alex, how did you find this?

We can try to cause an interrupt using a signal from another thread, but 
that's too difficult as the first test in a test suite.

-- 
error compiling committee.c: too many arguments to function

