Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbZD1LGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbZD1LGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZD1LGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:06:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41271 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbZD1LGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:06:00 -0400
Message-ID: <49F6E313.7020502@redhat.com>
Date: Tue, 28 Apr 2009 14:05:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58D75.7040304@redhat.com> <49F5B2DA.5060207@novell.com> <49F6CDFC.6000400@redhat.com> <49F6DB9D.3080501@novell.com> <49F6E1CA.1010106@redhat.com> <49F6E2BB.9070604@novell.com>
In-Reply-To: <49F6E2BB.9070604@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>>> But eventfd_signal basically marries us to eventfd.
>>>>     
>>>>         
>>> Well, only if we expect the fd to have eventfd semantics.  There are
>>> advantages to doing so, as we have discussed, because things like AIO
>>> can polymorhpically signal an interrupt without even knowing whats
>>> behind the eventfd.  But this isn't a strict requirement to support
>>> AIO.  Really all we need is a way for both kernel and userspace to
>>> signal.  Perhaps I should export an "irqfd_signal()" function from kvm,
>>> which today will map to eventfd_signal(), and tomorrow to ??.  I don't
>>> think using f_ops->write() is an option for in-kernel signaling, so we
>>> need some kind of interface here.
>>>
>>> Does that sound reasonable?
>>>   
>>>       
>> irqfd_signal() ties the user of irqfd to kvm.  I want this user to be
>> independent of kvm; it should work with eventfd, kvm's eventfd
>> lookalike (if we move away from eventfd) or pipes.
>>     
>
> So what is your proposal for such interface?
>
>   

->write().

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

