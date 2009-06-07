Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZFGNkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZFGNkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZFGNk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:40:26 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40516 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbZFGNkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=v0cRojwqS4Z+8EidlTIGks3JIN/WuOmV6XurydmuF4alsI/NAfcMg3F0vecUtpRUsg
         Kfq5QmWYIJht73mVtkBunk92t96QSzTLUIiARZ8QGeou2B0l6ECO8G2fxQ2WZXK3PQsp
         shgvzKSGKoKVrf3DYgFNXw/+GUXkpZXatDLS8=
MIME-Version: 1.0
In-Reply-To: <4A2BBC30.2030300@lwfinger.net>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
Date: Sun, 7 Jun 2009 16:40:24 +0300
X-Google-Sender-Auth: 322b7548213da9ad
Message-ID: <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hugh@veritas.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On Sun, Jun 7, 2009 at 4:10 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.29.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13319
>> Subject               : Page allocation failures with b43 and p54usb
>> Submitter     : Larry Finger <Larry.Finger@lwfinger.net>
>> Date          : 2009-04-29 21:01 (40 days old)
>> References    : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>> Handled-By    : Johannes Berg <johannes@sipsolutions.net>
>
> This bug is extremely difficult to pin down. I cannot reproduce it at
> will. The system has to be up for a long time, which is difficult with
> testing the late RC's of 2.6.30 and the code in wireless-testing so
> that new bugs don't end up in 2.6.31-RCX. That said, it still was in
> 2.6.30-RC6 and I'm not aware of any changes since that would fix it.
>
> My operating kernel is patched with additional diagnostics to help me
> understand why a kmalloc request for a buffer of 1390 bytes suddenly
> ends up as an O(1) request. Unfortunately, I don't have any answers.

Looking at the out-of-memory trace, there's still memory available but
the pskb_expand_head() allocation is GFP_ATOMIC so there's not much
the page allocator can do here. The amount of memory consumed by
inactive_file is pretty high so maybe the problem is related to the
recent mm/vmscan.c changes. Lets copy some more mm developers and see
if they can help out.

                        Pekka
