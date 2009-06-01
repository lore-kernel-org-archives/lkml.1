Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZFAS6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZFAS6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZFAS6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:58:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:45167 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZFAS6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nD5uZoYr2Wgwy13SQjzyEvCt6v3puLEyyz+g8IkxG34Y5lABBqkeudb7n1TXfssWXT
         Zkjnv79QLoP+qprZJJGiMKv6qYcdulD84ncoUiuucf2i/v/lDAFgHQQ6Mm/QaNyZnbO5
         MkYod696HDNmxpXTZfCpDcFSAFIIZO6kZrPrY=
Message-ID: <4A2424A2.5020704@gmail.com>
Date: Mon, 01 Jun 2009 20:57:38 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-13@gated-at.bofh.it>	<clqON-2Xv-15@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com> <4A1BEFB6.80205@kernel.org> <4A1C316C.9040201@gmail.com> <4A1C8444.9040605@kernel.org> <4A1D47C6.1070504@gmail.com>
In-Reply-To: <4A1D47C6.1070504@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niel Lambrechts wrote:
> On 05/27/2009 02:07 AM, Tejun Heo wrote:
>> The above is the offending failure and all three failfast bits are
>> set.  This corresponds to the following ATA exception.
<snip>
>> Can you please try the attached patch?  It takes suspend/resume cycle
>> out of the equation and simply induces artificial failure to readahead
>> requests.  It's currently set to fail every 40th readahead.  Feel free
>> to adjust the frequency as you see fit.  catting files into /dev/null
>> would trigger readahead to kick in.  Can you reproduce filesystem
>> failure with this alone?
>>    
>
> No corruption, I tried cat on an entire directory of mp3s, then also
> started X, but there the messages debug output got fairly drastic so I
> didn't care to continue for an entire day.
>
> It did trigger the "XXX ...failing readahead" message nearly 300
> times, and I also did a s2disk and resume cycle in there - so I hope
> this is enough for us to conclude that it is not the cause. 

Hi Tejun,

Did you perhaps have any time to look into my feedback around the
readahead patch?

>From my side, I tried on Saturday to bisect this problem again, doing
5-8 hibernates per each bisect from 2.6.28. I stopped at 2.6.30-rc2 due
time (or fatigue), and did not manage to replicate the problem at all
which is strange since I was playing audio, doing finds and even doing
an entire dd of the root partition. I saved the bisect logs so perhaps I
can continue to see if the problem becomes more prevalent in later
versions - the first time it ever happened to me was somewhere in 2.6.29
originally.

The other interesting thing was to see that "hard resetting link"
messages seem to first start appearing at v2.6.29-rc7 or perhaps rc8. Is
it worth trying to track down the commit that lead to this?

Do you have any other debug patches to try, or should I try to delve
deeper into finding commits that can be reverted? I'm running out of
ideas, I even tried to find later firmware for my drive, but I seem to
be on the latest level.

Thanks for the help so far!

Niel


