Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab0BXUAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:00:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:57241 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757907Ab0BXUAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:00:06 -0500
Subject: Re: [PATCH 11/11] KVM: SVM: Optimize nested svm msrpm merging
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4B8584D5.8010303@redhat.com>
Date: Wed, 24 Feb 2010 21:00:03 +0100
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BD84D15A-4BB2-482E-BDDE-95D1683996A7@suse.de>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com> <1267034360-5907-12-git-send-email-joerg.roedel@amd.com> <402BABD5-304A-47EA-B35C-D0E3948BB27E@suse.de> <20100224193700.GE3168@amd.com> <4B8584D5.8010303@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24.02.2010, at 20:58, Avi Kivity wrote:

> On 02/24/2010 09:37 PM, Joerg Roedel wrote:
>> 
>>> Isn't there such a list around somewhere already? We really should
>>> only keep this list once throughout the whole code. If necessary, just
>>> create the list on the fly when bits get set in the msrpm.
>>>     
>> No, the list is hardcoded in 3 functions (as parameter of
>> set_msr_interception). I think about a variant to do this with a single
>> list. Probably I create a list of MSRs and check in
>> set_msr_interceptionm for it.
>> 
>>   
> 
> Or, have set_msr_interception() create the list of offsets.

Or even better yet put the list into BSS because it should be static anyways. From that the real MSRPM and the merging function can be fed.

Alex