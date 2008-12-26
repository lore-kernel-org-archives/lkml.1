Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYLZLqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYLZLqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 06:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYLZLqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 06:46:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:8584 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYLZLqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 06:46:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NwThhaZCxPVf6CKvjTDYi26pan2L4N19KN++t71mAB2/Mv1SH5MqH2KY/bCs3Am5aE
         4vGLdWn4hxnJW3ZLIbeCl57iBCDHtsOQNVAydzZdiZplZCetWuvvAMk6HBkRupqOIhQi
         LbG0pFvY4rn8OYHogZ/DkJyo/0003dZKoZ18A=
Message-ID: <2f11576a0812260346j2df02362q52c8f813981a7773@mail.gmail.com>
Date: Fri, 26 Dec 2008 20:46:03 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
Cc: "Roland McGrath" <roland@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
In-Reply-To: <4954A7BE.6080204@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081219195311.81C4AFC351@magilla.sf.frob.com>
	 <49547836.7040907@hitachi.com>
	 <20081226153931.5CBB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <4954A7BE.6080204@hitachi.com>
X-Google-Sender-Auth: 1352dcc7a1878e40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>However, we would need a special care for PID namespace if we use
>>>>>init's coredump_filter as default.  For a process with new PID
>>>>>namespace and new /proc, writing to /proc/1/coredump_filter doesn't
>>>>>mean changing default, although it's not a usual operation.
>>>>
>>>>I'd figured that private PID namespaces with their own init would want
>>>>their own private settings for this default too.
>>>
>>>Probably it's true, but I'm not sure if having coredump_filter have
>>>two means is acceptable.  init in a private PID namespace can die
>>>and dump a core file.  So its coredump_filter has two means; default
>>>setting for the namespace and setting for itself.
>>
>> FWIW, I think private namespace should have private settings framework.
>> I don't like to make special private settings code in this patch.
>>
>> Yeah, defenitely we need to private settings for various reason, I agreed.
>> but we also need consistent private settings rule and framework.
>> otherwise, we will make various non consistent crap. maybe..
>
> Anyway, as Andrew pointed out, current coredump filter doesn't
> care for user mode helpers.  So we need some sort of changes in
> coredump filter so that users can change user mode helpers'
> settings; use child_reapers setting as default (Roland's
> suggestion) or use a boot parameter.

hm, ok.
I agreed your patch is nice.

      Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
