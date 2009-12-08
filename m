Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbZLHJPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbZLHJPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZLHJPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:15:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:45880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZLHJPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:15:52 -0500
Message-ID: <4B1E195D.50802@kernel.org>
Date: Tue, 08 Dec 2009 18:16:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] sched: implement try_to_wake_up_local()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-8-git-send-email-tj@kernel.org>	 <1259923487.3977.1940.camel@laptop>  <4B1C75F3.9080808@kernel.org>	 <1260175804.8223.1217.camel@laptop> <1260176199.8223.1237.camel@laptop>	 <4B1CD89F.9000802@kernel.org> <1260262394.3935.981.camel@laptop>
In-Reply-To: <1260262394.3935.981.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 05:53 PM, Peter Zijlstra wrote:
> On Mon, 2009-12-07 at 19:27 +0900, Tejun Heo wrote:
>>
>>> What happens when you run out of memory and the workqueue progress is
>>> needed to get free memory?
>>
>> That's when the "rescuer" workers kick in.  All workqueues which might
>> be used during allocation paths are required to have one.  When
>> manager fails to fork a new worker, it summons the rescuers.  They
>> migrate to the distressed cpu and processes only the works from their
>> specific workqueues thus guaranteeing forward progress.
> 
> What happens if the rescue worker is tied up on another cpu in a
> deadlock avoidance game, which requires progress on this cpu in order to
> resolve it?

Hmmm.... I think one rescuer thread per a workqueue is enough to
guarantee forward-progress.  If there are workqueues which have
inter-cpu dependency, we'll probably need per-cpu rescuers but is
there any?

Thanks.

-- 
tejun
