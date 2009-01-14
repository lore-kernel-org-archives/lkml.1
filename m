Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZANGpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZANGpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZANGph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:45:37 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:15714 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZANGpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:45:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ma0v5X8ns1UE7QXlWS8BxdEXIFG55uU0y+gOOmnEtfafPLQ7nHKj4rkR4gylbmMoUV
         TGymcfCEghS022huKCu3W9D/r/kPFSXhM1XZ+CeUUVmTlnKubx/jIIDt0/Yiwx0qw59t
         9CfuO7T/2g9bo5Ll6lH/GkjpzAQ3dRjVqyhc4=
Message-ID: <28c262360901132245j8fe121naf1d6b1450b4cade@mail.gmail.com>
Date: Wed, 14 Jan 2009 15:45:35 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "=?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?=" <arve@android.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@surriel.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: lowmemory android driver not needed?
Cc: "Brian Swetland" <swetland@google.com>, "Greg KH" <greg@kroah.com>,
       arve@google.com, "San Mehat" <san@android.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Robert Love" <rlove@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20090114010223.GA21380@kroah.com>
	 <20090114021801.GA14759@bulgaria.corp.google.com>
	 <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0E6jowM007740

Hi, Arve.
On Wed, Jan 14, 2009 at 11:30 AM, Arve HjÃ¸nnevÃ¥g <arve@android.com> wrote:> The oom killer does not kick in until all caches are emptied. Our user> space code changes the oom_adj value of processes that are no longer> in the foreground so that they killed first (the process saves its> state but does not exit). To avoid excessive demand paging, the low> memory killer will kill these processes when the memory available> drops below a threshold.

It have some problems. (drivers/staging/android/lwmemorykiller.c)
1. lowmem_shrink function have to answer about vm's query the cache size fast.2. it don't consider page size and memory size when it makelowmem_minfree's values.3. If system have many processes, for_each_process take a long time.it may result system latency although lowmemkiller intend to avoidlatency.4. Most important thing. Could we use memory controller instead oflowmemkiller ? I am not sure since I don't follow up memory controllerin these days.
I think we have to use existing facility if possible.Previously, There are similar kinds of patches. but It can't mergemainline due to some issue.  They can comment about lowmemkiller. Iwill CC them.
> --> Arve HjÃ¸nnevÃ¥g>>> On Tue, Jan 13, 2009 at 6:18 PM, Brian Swetland <swetland@google.com> wrote:>>>> Looping in Arve who wrote the low memory killer and can explain things>> in more detail.>>>> Brian>>>> [Greg KH <greg@kroah.com>]>>> Hi San,>>>>>> Alan Cox pointed me at the /proc/<pid>/oom_adj file that controls the>>> oom-killer score for any process as being more than sufficent to control>>> the oom killer.>>>>>> This makes me wonder why you wrote the android lowmemlorykiller driver?>>>>>> What is that driver for that is not already present in the existing>>> oom_* values for every process?>>>>>> thanks,>>>>>> greg k-h>> -->> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in>> the body of a message to majordomo@vger.kernel.org>> More majordomo info at  http://vger.kernel.org/majordomo-info.html>> Please read the FAQ at  http://www.tux.org/lkml/>>> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html> Please read the FAQ at  http://www.tux.org/lkml/>


-- Kinds regards,MinChan Kimÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
