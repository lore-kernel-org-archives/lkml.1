Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYFKSb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYFKSb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYFKSbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:31:19 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:47529 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYFKSbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=osmHuvZscpKiit3RO6kkgBtJLsBWVoMGeEAQ9gqteXw6ApZAz+A+ieuFwYT1W9FzWm
         K68wej4bCO7aL7wx0Ioh2tds1bTnXf1eNbhgnOMbjrd3Whb8BxuL7Q4qDEN9bbI/OgbJ
         QwRG7mSDJ6V6YzoO/ZFt1pBNqroa47gGZDsHU=
Message-ID: <dd18b0c30806111131gc1b506cva12f577ebb4afdf9@mail.gmail.com>
Date: Wed, 11 Jun 2008 18:31:17 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <dd18b0c30806110045s6d19a034yd89b892441bd1621@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>
	 <20080404012147.abf8a598.akpm@linux-foundation.org>
	 <484F31B8.8030001@gmail.com>
	 <dd18b0c30806110045s6d19a034yd89b892441bd1621@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 7:45 AM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Wed, Jun 11, 2008 at 2:00 AM, Tejun Heo <htejun@gmail.com> wrote:
>> Andrew Morton wrote:
>>> On Fri, 4 Apr 2008 05:07:45 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
>>>
>>>> When playing a DVD and then suspending the system while the DVD is
>>>> still in play, upon wakeup I'm receiving a Buffer I/O error on device
>>>> sr0, logical block 356490.
>>>> the DVD will continue to play but then gmplayer complains: Warning!
>>>> FPS changed 23.976 -> 29.970 (-5.994005) [4] then the video becomes
>>>> very choppy. When looking at osx in the same test the DVD will be
>>>> paused until the cd player aligns itself, then playback will start.
>>>> With looking further at this I think this is an issue of a library or
>>>> codec, So with this in mind is there a package that I might look at to
>>>> see if this resolves the issue. Attached is dmesg of the Buffer I/O
>>>> regards;
>>>
>>> An ata thing, I assume.  Let's cc linux-ide.
>>>
>>> Is this new behaviour in 2.6.25-rc8, or were earlier kernels OK?
>>
>> This is due to UNIT ATTENTION condition triggered by reset during
>> resume.  The following patches should fix it.
>>
>> http://marc.info/?l=linux-ide&m=121309016918976&w=2
>> http://marc.info/?l=linux-ide&m=121309016918979&w=2
>>
>> Thanks.
>>
>> --
>> tejun
>>
>
> alright!! I'll give that a test and see; give me some time right now
> it's midnight, and a couple of beer's in; so doing anything that
> requires
> thinking isn't going to happen, but tomorrow it will.
> regards;
>
> --
> Justin P. Mattock
>

O.K. I applied the patch here is what I'm seeing:

[  920.237141] end_request: I/O error, dev sr0, sector 2931560
[  920.237141] Buffer I/O error on device sr0, logical block 366445
[  920.237141] Buffer I/O error on device sr0, logical block 366446
[  920.237141] Buffer I/O error on device sr0, logical block 366447
[  920.237141] Buffer I/O error on device sr0, logical block 366448
[  920.237141] Buffer I/O error on device sr0, logical block 366449
[  920.237141] Buffer I/O error on device sr0, logical block 366450
[  920.237141] Buffer I/O error on device sr0, logical block 366451
[  920.237141] Buffer I/O error on device sr0, logical block 366452
[  920.237141] Buffer I/O error on device sr0, logical block 366453
[  920.237141] Buffer I/O error on device sr0, logical block 366454
[  925.431105] __ratelimit: 10100 messages suppressed
[  925.431118] Buffer I/O error on device sr0, logical block 371516
[  930.772658] __ratelimit: 2407 messages suppressed
[  930.772658] Buffer I/O error on device sr0, logical block 372720
[  935.674943] __ratelimit: 6995 messages suppressed
[  935.674955] Buffer I/O error on device sr0, logical block 376218
[  940.685317] __ratelimit: 16949 messages suppressed
[  940.685329] Buffer I/O error on device sr0, logical block 384693
[  945.770547] __ratelimit: 17881 messages suppressed
[  945.770558] Buffer I/O error on device sr0, logical block 393634
[  950.777243] __ratelimit: 19031 messages suppressed
[  950.777243] Buffer I/O error on device sr0, logical block 403150
[  955.788427] __ratelimit: 19035 messages suppressed
[  955.788439] Buffer I/O error on device sr0, logical block 412668
[  961.575327] __ratelimit: 16603 messages suppressed
[  961.575338] Buffer I/O error on device sr0, logical block 420970
[ 1006.919733] __ratelimit: 9315 messages suppressed

Almost as if the drive is taking to long to think, by then the cache
has run out, and the FPS changes,
the movie itself doesn't become choppy like before, just freezes.
If you have any other ideas I'm up for that to see.
regards;

-- 
Justin P. Mattock
