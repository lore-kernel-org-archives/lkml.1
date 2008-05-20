Return-Path: <linux-kernel-owner+w=401wt.eu-S933426AbYETO5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbYETO5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933342AbYETO4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:56:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:4525 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337AbYETO4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:56:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ISIgdmEvvd3HUzUuK3dhg0Fqkp/38CyakD3T5FM7NXkEzsm4wZbCK3CR7jsaDhfMH9j+FaIUtPpTbHF0yiW2jgBfnILHIu376asZz1spnsMLv/wZsvagua0EQxu2qi5Apjnr4aSPT1PPyJtqXoHj+vqC/DNG92DUaIfuxQ7aHnA=
Message-ID: <cfd18e0f0805200756t1e7e33d7rd3ea5b2ecc1e87dc@mail.gmail.com>
Date: Tue, 20 May 2008 16:56:48 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Nadia Derbey" <Nadia.Derbey@bull.net>
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <4832E423.5040708@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0805200728j1f38d90s1f6355b71e2d76@mail.gmail.com>
	 <4832E423.5040708@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixing the bad list address in my initial mail: CC += linux-mm@kvack.org]

On Tue, May 20, 2008 at 4:45 PM, Nadia Derbey <Nadia.Derbey@bull.net> wrote:
> Michael Kerrisk wrote:
>>
>> Hello Nadia,
>>
>> Regarding your:
>>
>> [PATCH 1/8] Scaling msgmni to the amount of lowmem
>> http://article.gmane.org/gmane.linux.kernel/637849/
>> which I see has made its way in 2.6.26-rc
>>
>> Your patch has the following change:
>>
>> -#define MSGPOOL (MSGMNI*MSGMNB/1024)  /* size in kilobytes of message
>> pool */
>> +#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
>>
>> Since this constitutes a kernel-userland interface change, so please
>> do CC me, so that I can change the man pages if needed.
>
> Oops, sorry for not doing it: I misunderstood the "unused"
>
>>
>> The man page
>> (http://www.kernel.org/doc/man-pages/online/pages/man2/msgctl.2.html)
>> does indeed say that msgpool is "unused".  But that meant "unused by
>> the kernel" (sorry -- I probably should have worded that text better).
>>  And, as you spotted, the page also wrongly said the value is in
>> bytes.
>>
>> However, making this change affects the ABI.  A userspace application
>> that was previously using msgctl(IPC_INFO) to retrieve the msgpool
>> field will be affected by the factor-of-1024 change.  I strongly
>> suspect that there no such applications, or certainly none that care
>> (since this value is unused by the kernel).  But was there a reason
>> for making this change, aside from the fact that the code and the man
>> page didn't agree?
>>
>
> No, that was the only reason.
> Should I repost a patch to set it back as it used to be?

On the one hand, I'd be inclined to leave things as they were pre
2.6.26.  On the other hand, I believe that on other systems that have
the limit, msgpool is a limit in bytes.  (But documentation of these
details on other systems is very thin on the ground.)  I wonder if
anyone else has some knowledge here?


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
