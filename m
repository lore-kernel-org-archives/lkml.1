Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZHYG7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZHYG7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZHYG7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:59:37 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40972 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbZHYG7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jzSE9uzHrW9m3+jgutjNnl4jxjOI+U3HaOJpEBitkZstOBRtJ9XxyN3vMgg4/5qpa3
         TqIW5cINhS3Ge7z5DBlEN4N2Sh1oLQbAglXFOVZzHBsiV1XYaFaesb/st3henWl1Zx9Y
         ipCJFFdjOEK1b2z0s25jigCl1PFMDHAobzZik=
Message-ID: <4A938BD5.1050302@gnu.org>
Date: Tue, 25 Aug 2009 08:59:33 +0200
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <4A92DC93.6030406@redhat.com> <alpine.DEB.2.00.0908241503150.7951@makko.or.mcafeemobile.com> <4A930FE4.6090209@gnu.org> <alpine.DEB.2.00.0908241515150.7951@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0908241515150.7951@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> There are userspace libraries that do almost everything, but you hardly
>>> see things like pthread_(EFD_STATE-like)_create() or similar system
>>> interfaces based on such abstraction.
>>
>> It actually seems as close to a condition variable as an eventfd can be.
>
> A pthread condition typical code usage maps to eventfd like:
>
> 	while (read(efd, ...)>  0)
> 		if (CONDITION)
> 			break;
>
> So a pthread condition is really a wakeup gate like eventfd is.
> EFD_STATE has nothing to do with a pthread condition.

No, your code does not work for pthread_cond_broadcast (which arguably 
is the common case) because all the eventfd readers after the first 
would block.

Paolo
