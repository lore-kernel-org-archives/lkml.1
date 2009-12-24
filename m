Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZLXLks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZLXLks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbZLXLkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:40:47 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:58500 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbZLXLkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=YsvhGzTHRVJhrgmJvTKAYtrp6iplWj+U1xfnDnZtadaoFXGE9J6ycoxFhBgQ2JcNQG
         0kMyvAhh5O4UQtEq2smd5gsmqy+2B4JRaIPIpOoCVYcZfUxDCpamkaqxnw3bOdDf3vdN
         XBZO90bylmO4eWCNl5nRmkHcoy3j16iE9a664=
MIME-Version: 1.0
In-Reply-To: <20091224091919.GA17516@sli10-desk.sh.intel.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	 <4B331CD6.1070207@cn.fujitsu.com>
	 <20091224091919.GA17516@sli10-desk.sh.intel.com>
Date: Thu, 24 Dec 2009 12:40:39 +0100
Message-ID: <4e5e476b0912240340x3769f7fdk56f10dfdad10fbf7@mail.gmail.com>
Subject: Re: cfq-iosched: tiobench regression
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default setting should satisfy most users (how many desktop users
run 32 concurrent seq.readers?).
Those who have particular needs (e.g. DB users) can try their workload
with both settings. low latency can probably benefit them too, if the
workload is latency sensitive.

Corrado

2009/12/24, Shaohua Li <shaohua.li@intel.com>:
> On Thu, Dec 24, 2009 at 03:48:38PM +0800, Gui Jianfeng wrote:
>> Shaohua Li wrote:
>> > We see about 30% regression in tiobench 32 threads 80M file sequential
>> > read.
>> > The regression is caused by below commits.
>> >
>> > 5db5d64277bf390056b1a87d0bb288c8b8553f96
>> > The commit makes the slice too small. In the test, the slice is limitted
>> > to 2 * idle_slice(300ms/32 < 2*idle_slice). This dramatically impacts io
>> > thoughput. The low_latency knob used to be only impact random io, now it
>> > impacts sequential io too. Any idea to fix it?
>>
>> Hi Shaohua,
>>
>> IMHO this shouldn't be a problem. Currently, low_latency is used to
>> improve
>> the latency for the whole system. If someone would like to achieve high
>> throughput,
>> just turn off low_latency knob.
> The concern is low_latency is default on. A end user is unlikely to know the
> knob.
>
> Thanks,
> Shaohua
>

-- 
Inviato dal mio dispositivo mobile

__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
