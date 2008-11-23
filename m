Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYKWDso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYKWDso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 22:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYKWDsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 22:48:33 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:24401 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbYKWDsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 22:48:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RNx1jHYY+RLSEohiip6HK9g4lUIRK47dOQC6mUEF8igwYeSfupkucwqHd0L47q3U1x
         +4A1krckBNHp9Dtk1gh7E1cHguY3vNQ9tzv5dM64sGSPXi30Je0z+UewGCA+p2rbhsxZ
         BGxzxs7HHYpOmB4WX3NeBDUkcaWS84d1b+kZI=
Message-ID: <4928D2A2.4030304@gmail.com>
Date: Sun, 23 Nov 2008 12:48:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Brad Boyer <flar@allandria.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>, rminnich@sandia.gov,
       ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: poll: allow f_op->poll to sleep, take #3
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com> <4928C891.80405@gmail.com> <20081123033457.GA1912@cynthia.pants.nu>
In-Reply-To: <20081123033457.GA1912@cynthia.pants.nu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Boyer wrote:
> On Sun, Nov 23, 2008 at 12:05:53PM +0900, Tejun Heo wrote:
>> I thought try_to_wake_up() was made static to avoid abuse but then again
>> creating dummy waitqueue is an obvious abuse of waitqueue.  What do
>> other people think?  I'll be happy to use try_to_wake_up() directly.
> 
> Do you need all the extra arguments? The function wake_up_process()
> is already a wrapper around try_to_wake_up() and is exported, but
> it doesn't have any arguments other than the task_struct and uses
> defaults for the other arguments. I'm not sure if anything in your
> code would break by ignoring the other possible values instead of
> passing them along from the arguments into the caller.

Hmmm... there was something which made wake_up_process() inappropriate.
 Ah, okay, it was @mode.  We can add a WARN_ON() if @mode is an
unexpected value and use a fixed one - TASK_INTERRUPTIBLE or TASK_ALL -
but that's even hackier than the waitqueue hack.

Thanks.

-- 
tejun
