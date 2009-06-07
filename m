Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZFGOdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZFGOdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZFGOcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:32:53 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33583 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbZFGOcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qyv0CaBG9pj0fMkXS1pA5dT3XseCG53NUV2aK4tSU0G+inQ245TSxyEiC/2ENlmpFR
         exuwBd8UjvxZBjgwOfpT0AjPUE0mAmiN/GRuHi4ZqHXwn2lHG5YDBYZs6+zZa5wiehr6
         1kY4ZT9NBKb1miq9Oam3QvbCRN0E7bRfACKaY=
MIME-Version: 1.0
In-Reply-To: <4A2BCC6F.8090004@redhat.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
Date: Sun, 7 Jun 2009 17:32:52 +0300
X-Google-Sender-Auth: 5b02dc2a3180da5e
Message-ID: <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Rik van Riel <riel@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 5:19 PM, Rik van Riel <riel@redhat.com> wrote:
> Pekka Enberg wrote:
>>
>> Hi Larry,
>>
>> On Sun, Jun 7, 2009 at 4:10 PM, Larry Finger <Larry.Finger@lwfinger.net>
>> wrote:
>>>
>>> Rafael J. Wysocki wrote:
>>>>
>>>> This message has been generated automatically as a part of a report
>>>> of recent regressions.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> from 2.6.29.  Please verify if it still should be listed and let me know
>>>> (either way).
>>>>
>>>>
>>>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13319
>>>> Subject               : Page allocation failures with b43 and p54usb
>>>> Submitter     : Larry Finger <Larry.Finger@lwfinger.net>
>>>> Date          : 2009-04-29 21:01 (40 days old)
>>>> References    : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>>>> Handled-By    : Johannes Berg <johannes@sipsolutions.net>
>>>
>>> This bug is extremely difficult to pin down. I cannot reproduce it at
>>> will. The system has to be up for a long time, which is difficult with
>>> testing the late RC's of 2.6.30 and the code in wireless-testing so
>>> that new bugs don't end up in 2.6.31-RCX. That said, it still was in
>>> 2.6.30-RC6 and I'm not aware of any changes since that would fix it.
>>>
>>> My operating kernel is patched with additional diagnostics to help me
>>> understand why a kmalloc request for a buffer of 1390 bytes suddenly
>>> ends up as an O(1) request. Unfortunately, I don't have any answers.
>>
>> Looking at the out-of-memory trace, there's still memory available but
>> the pskb_expand_head() allocation is GFP_ATOMIC so there's not much
>> the page allocator can do here. The amount of memory consumed by
>> inactive_file is pretty high so maybe the problem is related to the
>> recent mm/vmscan.c changes. Lets copy some more mm developers and see
>> if they can help out.
>
> That is a very strange trace.  The Mem-Info indicates
> that the system has more than enough memory free, and
> also enough memory in higher-order free blocks.
>
> This would indicate a bug somewhere in the page
> allocator - this memory should have been given to this
> allocation request.

Aha, I always have difficulties deciphering the traces. But lets
invite Mel to the party then!

                        Pekka
