Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZANCax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZANCax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZANCan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:30:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:17138 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZANCam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:30:42 -0500
Message-ID: <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
Date: Tue, 13 Jan 2009 18:30:39 -0800
From: "=?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?=" <arve@android.com>
To: "Brian Swetland" <swetland@google.com>
Subject: Re: lowmemory android driver not needed?
Cc: "Greg KH" <greg@kroah.com>, arve@google.com, "San Mehat" <san@android.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Robert Love" <rlove@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090114021801.GA14759@bulgaria.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090114010223.GA21380@kroah.com>
	 <20090114021801.GA14759@bulgaria.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oom killer does not kick in until all caches are emptied. Our user
space code changes the oom_adj value of processes that are no longer
in the foreground so that they killed first (the process saves its
state but does not exit). To avoid excessive demand paging, the low
memory killer will kill these processes when the memory available
drops below a threshold.

-- 
Arve Hjønnevåg


On Tue, Jan 13, 2009 at 6:18 PM, Brian Swetland <swetland@google.com> wrote:
>
> Looping in Arve who wrote the low memory killer and can explain things
> in more detail.
>
> Brian
>
> [Greg KH <greg@kroah.com>]
>> Hi San,
>>
>> Alan Cox pointed me at the /proc/<pid>/oom_adj file that controls the
>> oom-killer score for any process as being more than sufficent to control
>> the oom killer.
>>
>> This makes me wonder why you wrote the android lowmemlorykiller driver?
>>
>> What is that driver for that is not already present in the existing
>> oom_* values for every process?
>>
>> thanks,
>>
>> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
