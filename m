Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZHHIdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZHHIdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 04:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZHHIdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 04:33:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:41940 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZHHIdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 04:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qd0Fs+IYhPQ2ESVJllO8iQyDlDqAl1QHRq97oLjLjsPNpOW5VyGCbadOkYCyAmFObY
         qdTku2dFEuNGWYNPUxupwzD2Hd7qZcdBEyZqAbimPygJ9F9iP1wKKVZazCZNBSMvyUNd
         MQyip47klqs+40FxF//nW4ywiNviIIODIgURk=
MIME-Version: 1.0
In-Reply-To: <1249657743.32113.733.camel@twins>
References: <20090807094608.4b0efea1@torg> <1249657743.32113.733.camel@twins>
Date: Sat, 8 Aug 2009 16:33:18 +0800
Message-ID: <d82e647a0908080133g7aa3e62fqcc52054ba57a32f1@mail.gmail.com>
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Clark Williams <williams@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       "greg@kroah.com" <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/7 Peter Zijlstra <peterz@infradead.org>:
> On Fri, 2009-08-07 at 09:46 -0500, Clark Williams wrote:
>> Peter,
>>
>> I'm getting this warning from lockdep when booting on my T60.
>>
>> The two addresses reported (0xffffffff812664a2 and 0xffffffff812664ae)
>> actually bracket one call to mutex_lock() in driver_attach() so I'm not
>> sure what the complaint is.
>>
>> Clark
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 2.6.31-rc5-rt1.1 #37
>> ---------------------------------------------
>> swapper/1 is trying to acquire lock:
>>  (&dev->mutex){+.+...}, at: [<ffffffff812664ae>]
>> __driver_attach+0x48/0x81
>>
>> but task is already holding lock:
>>  (&dev->mutex){+.+...}, at: [<ffffffff812664a2>]
>> __driver_attach+0x3c/0x81
>>
>> other info that might help us debug this:
>> 1 lock held by swapper/1:
>>  #0:  (&dev->mutex){+.+...}, at: [<ffffffff812664a2>]
>> __driver_attach+0x3c/0x81
>
> Oh, that's tglx who's gone wild with sem->mutex conversions.

Maybe we can introduce some mutex interfaces which bypass lockdep validation
temporarily to allow driver core to convert to mutex from sema if lockdep
can't validate tree-structured lock orderings.

Thanks.

--
Lei Ming
