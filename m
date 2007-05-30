Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbXE3NnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbXE3NnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXE3NnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:43:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:31726 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbXE3NnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aF8ecuwNVEBpK8CiM+te/twC+t4pM2LHJJlZYWHF6LhXxakHpSXB16UzJqexq9peY6tmpfT3l2zs7GU7tyrIP3WHVZoLXLReRvn+y9g2ETU2apAbmWpMsEbWuIRpXuQJNxVDAclstfuo6lakh24FpxTx2zaD3sbZDf8vTXDPblo=
Message-ID: <465D7F2C.4040203@gmail.com>
Date: Wed, 30 May 2007 22:42:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: epoll,threading
References: <MDEHLPKNGKAHNMBLJOLKGEJIEBAC.davids@webmaster.com> <465C809C.60507@gmail.com> <20070530072528.GP943@1wt.eu> <465D4DF1.5040500@gmail.com> <20070530131221.GC19105@1wt.eu>
In-Reply-To: <20070530131221.GC19105@1wt.eu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Willy Tarreau wrote:
>> The thing is that the synchronization overhead is something you'll have
>> to pay anyway to support multiple processors.
> 
> But you don't need to sync *everything*. It is doable to have 1 thread
> per processor, each with their own data, and sync the minimum information
> (eg: statistics).

Agreed it's doable but the list of things to synchronize tends to grow
and it's really hurts when it does.  Also, the list becomes much less
different between async and threaded model with multi processor support.

[--snip--]
>>  You need to restrict per-thread
>> stack size and use epoll for idle threads, if you wanna scale.  Workers
>> + async monitoring of idle clients scale pretty well.
> 
> I agree with a small pool of workers. But they must be dedicated to CPU
> only, and perform no I/O. Then you can have 1 thread/CPU.

Well, if you go that far, it's basically async model with multiprocessor
support.  Not my favorite one.  :-)

>>> However, I agree that few uses really require to spend time writing
>>> and debugging async programs.
>> Yeap, also there are several things which just are too painful in async
>> server - e.g. adding coordination with another server (virus scan,
>> sharing cached data), implementing pluggable extension framwork for
>> third parties (and what happens if they should be able to stack!), and
>> maintaining the damn thing while trying to add a few features.  :-)
>>
>> IMHO, complex pure async server doesn't really make sense anymore.
> 
> That's clearly not my opinion, but I don't want to enter a flamewar on
> the subject, it's not interesting. As long as people like us will push
> the system to limits using either model, at least there will be
> references for comparisons :-)

Yeap, it's getting off-topic.  Let's see what future brings.  :-)

Thanks.

-- 
tejun
