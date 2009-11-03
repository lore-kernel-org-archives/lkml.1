Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZKCOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZKCOip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZKCOip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:38:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbZKCOio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:38:44 -0500
Message-ID: <4AF04076.2070409@redhat.com>
Date: Tue, 03 Nov 2009 16:38:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] Handle asynchronous page fault in a PV guest.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-4-git-send-email-gleb@redhat.com> <20091103141423.GC10084@amt.cnet> <20091103142533.GN27911@redhat.com> <20091103143250.GD10084@amt.cnet>
In-Reply-To: <20091103143250.GD10084@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2009 04:32 PM, Marcelo Tosatti wrote:
> Any attempt to access the swapped out data will cause a #PF vmexit,
> since the translation is marked as not present. If there's swapin in
> progress, you wait for that swapin, otherwise start swapin and wait.
>
> Its not as efficient as paravirt because you have to wait for a timer
> interrupt and the guest scheduler to decide to taskswitch, but OTOH its
> transparent.
>    

With a dyntick guest the timer interrupt will come at the end of the 
time slice, likely after the page has been swapped in.  That leaves smp 
reschedule interrupts and non-dyntick guests.

An advantage is that there is one code path for apf and non-apf.  
Another is that interrupts are processed, improving timekeeping and 
maybe responsiveness.


-- 
error compiling committee.c: too many arguments to function

