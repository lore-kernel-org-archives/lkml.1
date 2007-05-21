Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbXEUFIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbXEUFIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXEUFHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:07:54 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:1787 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXEUFHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WkMWoCQh6gZ895KVWAvJUfOQdNEudR8feyAxrExARCS5vWX63pfJnh6jFfEvt5ke6ATU6y5fZQVAdFjJv/LW13l7qDfsNGMKXlq4K5ckbTt9f6eowrx2MgJRKTLWn7tfE9Tig3MtTASXO8y6o6SiSnLjttkQENnMbfdb4f23n8k=
Date: Mon, 21 May 2007 13:07:22 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: aeb@cwi.nl, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc2 built on ppc (3)
Message-ID: <20070521050722.GA2150@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: aeb@cwi.nl, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Cornelia Huck <cornelia.huck@de.ibm.com>
References: <20070520111113.GE3253@aragorn.home.lxtec.de> <20070520122351.GC2006@localhost.localdomain> <20070520154906.GA4314@aragorn.home.lxtec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520154906.GA4314@aragorn.home.lxtec.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 05:49:06PM +0200, Elimar Riesebieter wrote:
>On Sun, 20 May 2007 the mental interface of
>WANG Cong told:
>
>> On Sun, May 20, 2007 at 01:11:13PM +0200, Elimar Riesebieter wrote:
>> >Hi,
>> >
>> >FYI, building the kernel with
>> >gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
>> >on my powerbook (PPC) gives:
>> >
>> >...
>> >fs/partitions/check.c: In function 'add_partition':
>> >fs/partitions/check.c:392: warning: ignoring return value of 'kobject_add', declared with attribute warn_unused_result
>> >fs/partitions/check.c:395: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
>> >fs/partitions/check.c:403: warning: ignoring return value of 'sysfs_create_file', declared with attribute warn_unused_result
>> >...
>> >
>> >If more info is needed, please contact me via PM, as I am not
>> >subscribed.
>> >
>> >Thanks for your patience
>> >Elimar
>> >
>> 
>> I don't know why these warnings are still in kernel. We have fixed them yet. Could you please check and try this patch?
>> 
>> http://marc.info/?l=linux-mm-commits&m=117624330000536&w=2
>
>  CC      fs/partitions/check.o
>fs/partitions/check.c: In function 'add_partition':
>fs/partitions/check.c:398: error: 'struct kset' has no member named 'kset'
>make[2]: *** [fs/partitions/check.o] Error 1
>^make[1]: *** [fs/partitions] Error 2
>
>Elimar
>

Oh, bad. I think something about struct kset has changed since we made this patch. Thanks for your try.
And could you pleae try this?

-	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem"))
+	if (sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem"))

If that cann't help you, please ask Andrew for the corresponding patch, I believe it is still in Andrew's tree. Thanks again!

Regards!

