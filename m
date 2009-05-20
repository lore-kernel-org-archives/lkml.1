Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZETHJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZETHJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZETHJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:09:20 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:61697 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZETHJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uzMhlefE7ORWPI5q5D0sckRXNNY6FZe3xm3dyVj7f732+6OAJaSJeTodGq/oH22AAg
         9Hiabad7i2c8GcbaM60JCW/yr5pwp/qw+YnaMTCtxOhP1tOzQY6bkdpPMlIh6svB6B9X
         u5ZjF60cUOwxfNrWfQzEmR49B074pN4Tbg7QY=
MIME-Version: 1.0
In-Reply-To: <1242802064.31350.12.camel@johannes.local>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu>
	 <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
	 <1242802064.31350.12.camel@johannes.local>
Date: Wed, 20 May 2009 15:09:20 +0800
Message-ID: <d82e647a0905200009pc894d4yed0f81c83443a0ee@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency at 
	cleanup_workqueue_thread
From: Ming Lei <tom.leiming@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/20 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2009-05-20 at 11:36 +0800, Ming Lei wrote:
>
>> > Anyway, you can have a deadlock like this:
>> >
>> > CPU 3                   CPU 2                           CPU 1
>> >                                                        suspend/hibernate
>> >                        something:
>> >                        rtnl_lock()                     device_pm_lock()
>> >                                                        -> mutex_lock(&dpm_list_mtx)
>> >
>> >                        mutex_lock(&dpm_list_mtx)
>>
>> Would you give a explaination why mutex_lock(&dpm_list_mtx) runs in CPU2
>> and depends on rtnl_lock?
>
> Why not? Something is registering a hotplugged netdev.

I see. I just feel a bit curious how lockdep may build the dependency
of dpm_list_mtx on rtnl_lock,  and it  is certainly related with
lockdep internal.

-- 
Lei Ming
