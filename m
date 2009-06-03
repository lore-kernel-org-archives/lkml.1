Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZFCVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZFCVOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZFCVOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:14:18 -0400
Received: from mail.tmr.com ([64.65.253.246]:60955 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZFCVOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:14:18 -0400
Message-ID: <4A26E79B.2040306@tmr.com>
Date: Wed, 03 Jun 2009 17:14:03 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: J Louis <handstogether8@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux scheduler capabilities for batch jobs.
References: <6f41bd4b0906010641n1b360dffs6eaed72eb24f60f5@mail.gmail.com> <4A240479.9040907@redhat.com>
In-Reply-To: <4A240479.9040907@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> J Louis wrote:
> 
>> If it was possible to tell
>> the scheduler that it was OK not to be fair when scheduling these
>> processes, I think the total runtime could be reduced if it put some
>> of the processes to sleep while others completed.  Is there a way to
>> tell the scheduler it is allowed to do this?  Should there be?
> 
> There is no way to do this currently, but I suspect that it
> would not be too difficult to add.
> 
> Of course, if you have two tasks that are each a little larger
> than memory, your idea could lead to one of the processes being
> starved forever.  This is probably not acceptable :)
> 
> In fact, one single batch process that is swapping could trigger
> the algorithm you described, halting itself.  Your idea would
> need very carefuly implementation to avoid these kinds of issues,
> but I believe it could definately be done.
> 
I think it gets doubly hard because the processes may have parts swapped even if 
there isn't memory pressure, so you can't just use percentage in memory. If you 
were going to do this in an effective way you would really need to monitor swap 
rate per process, and factor in total size, so it's not trivial. Of course in 
the extreme cases it would be hard to avoid improvement, so it need not be 
perfect to be helpful.

-- 
Bill Davidsen <davidsen@tmr.com>
   Even purely technical things can appear to be magic, if the documentation is
obscure enough. For example, PulseAudio is configured by dancing naked around a
fire at midnight, shaking a rattle with one hand and a LISP manual with the
other, while reciting the GNU manifesto in hexadecimal. The documentation fails
to note that you must circle the fire counter-clockwise in the southern
hemisphere.

