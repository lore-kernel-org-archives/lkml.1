Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYHRRNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYHRRNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbYHRRNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:13:41 -0400
Received: from mail.lang.hm ([64.81.33.126]:57971 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbYHRRNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:13:40 -0400
Date: Mon, 18 Aug 2008 10:13:16 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: tvrtko.ursulin@sophos.com
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to
 a linux interface for on access scanning
In-Reply-To: <20080818155925.DC73A376469@pmx1.sophos.com>
Message-ID: <alpine.DEB.1.10.0808181011060.15109@asgard.lang.hm>
References: <20080818155925.DC73A376469@pmx1.sophos.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, tvrtko.ursulin@sophos.com wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 18/08/2008 16:31:48:
>
>>> Huh? I was never advocating re-scan after each modification and I even
>
>>> explicitly said it does not make sense for AV not only for performance
> but
>>> because it will be useless most of the time. I thought sending out
>>> modified notification on close makes sense because it is a natural
> point,
>>> unless someone is trying to subvert which is out of scope. Other have
>>> suggested time delay and lumping up.
>>
>> You need a bit more than close I imagine, otherwise I can simply keep
> the
>> file open forever. There are lots of cases where that would be natural
>> behaviour - eg if I was to attack some kind of web forum and insert a
>> windows worm into the forum which was database backed the file would
>> probably never be closed. That seems to be one of the more common attack
>> vectors nowdays.
>
> Yes, I agree that modification notifications are needed in some cases.
>
>>> Also, just to double-check, you don't think AV scanning would read the
>
>>> whole file on every write?
>>
>> So you need the system to accumulate some kind of complete in memory set
>> of 'dirty' range lists on all I/O ? That is going to have pretty bad
>> performance impacts and serialization.
>
> No, I was just saying scanning is pretty smart, it's not some brute force
> method of scan all data that is there. It has a file type detection and
> what and how to scan is determined by that. If a file does not resemble
> any file type I don't think it gets scanned. For example take couple of
> gigabytes of zeros and try to scan that with some products. I don't think
> they will try to read the whole file.

trying to include details of where each file was updated means that you 
can't just set a single 'dirty' flag for the file (or clear the 'scanned' 
flags), you instead need to detect and notify on every write.

this is a HUGE additional load on the notification mechansim and the 
software that recieves the notifications.

just sending "fix X was scanned and now isn't" is going to be bad enough, 
you _really_ don't want to do this for every write.

David Lang
