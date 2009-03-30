Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbZC3Ivd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbZC3Ivd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 04:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZC3IvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 04:51:20 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:31680 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZC3IvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 04:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=d7wQ/A7K0HnMUH5GjPxIZULjDhTw2kJaqCggzXBmCMwLWkzNMNIJ5AWCo5jWVjdxXl
         jC9HeJdRrsxJHlVUh/3gYdoLPl+UbKk22CuqR1abUzGPPDfSF2rukEGF8EoPj2uzPC6m
         RytYtIh8jfvQ1alMYrrjXbU10Z9UxxeGCvBFM=
Date: Mon, 30 Mar 2009 08:51:07 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       =?us-ascii?B?PT9JU08tODg1OS0yP1E/SWxwb19KPz0gPT9JU08tODg1OS0yP1E/PUU0?=
	 =?us-ascii?Q?rvinen=3F=3D?= <ilpo.jarvinen@helsinki.fi>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2927 tcp_ack+0xd55/0x1991()
Message-ID: <20090330085107.GA5822@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328075628.3565eb39@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-03-2009 14:56, Jonathan Corbet wrote:
> On Sat, 28 Mar 2009 10:55:14 +0100
> Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> 
>> Yes, you might be right, because running with CONFIG_PROVE_LOCKING and 
>> CONFIG_DETECT_SOFTLOCKUP enabled points to a possible bug in the BKL
>> removal patches (fasync) by Jonathan Corbet. (I wasn't able so far to
>> reproduce the original WARNING.)
>>
>> Here is one example:
>>
>> =========================================================
>> [ INFO: possible irq lock inversion dependency detected ]
>> 2.6.29-03321-gbe0ea69 #7
>> ---------------------------------------------------------
>> swapper/0 just changed the state of lock:
>>  (fasync_lock){..+.}, at: [<ffffffff8028a2ac>] kill_fasync+0x24/0x45
>> but this lock took another, hard-irq-unsafe lock in the past:
>>  (&f->f_lock){--..}
> 
> That's not a bug; f_lock will never be taken in IRQ mode.  There's a
> fix for the warning in linux-next now; my plan is to get it upstream
> before -rc1.

Probably I miss something, but generally in a case like this "a_lock"
doesn't have to be taken in IRQ mode to be dangerous. Eg. if one cpu
is trying to take this lock after fasync_lock (with IRQs disabled),
while another cpu is waiting for fasync_lock in IRQ, which preempted
such "a_lock".

Could you give some details of this fix?

Thanks,
Jarek P.
