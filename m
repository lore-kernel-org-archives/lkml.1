Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZIVRGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZIVRGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZIVRGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:06:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbZIVRF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:05:59 -0400
Message-ID: <4AB903E6.6030208@redhat.com>
Date: Tue, 22 Sep 2009 20:05:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
References: <4AB3CDEC.5050902@zytor.com>	 <1253342422-13811-1-git-send-email-avi@redhat.com>	 <4AB8980D.5070803@redhat.com>  <20090922143223.GA31702@elte.hu>	 <1253638205.18939.4.camel@laptop>  <4AB900B1.9070901@redhat.com> <1253638554.18939.5.camel@laptop>
In-Reply-To: <1253638554.18939.5.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 07:55 PM, Peter Zijlstra wrote:
>> If you're using lockdep, surely that's not your biggest worry?
>>      
> No, but that's all under #ifdef and fully disappears when not enabled.
> Generic return-tu-user notifiers don't sound like they will though.
>    

They will if not selected.  If selected and not armed, they will have 
zero runtime impact since they piggyback on existing branches 
(_TIF_DO_NOTIFY_MASK and near relatives).  If selected and armed they'll 
cause __switch_to_xtra() on every context switch and do_notity_resume() 
on syscall exit until disarmed, but then you've asked for it.

-- 
error compiling committee.c: too many arguments to function

