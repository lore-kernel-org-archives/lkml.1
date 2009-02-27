Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZB0O4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZB0O4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 09:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZB0O4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 09:56:45 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:41343 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZB0O4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 09:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DGRxqpuFKiojZBKY/ABIJ0mnO4Tia+b2ag50+KejUZ724kPiQmY+pYiD6Hb3R0SHf6
         P/LyX9Sbn73Z+0g+kO0v5m4TskB1aX+jSXNzihJGeC+ZgfzTgYH3qUV/4rnSsoxHOOLJ
         uBvTbqMnAYvuDkjvBEX0+j4uYBEeg9ihnt+XQ=
MIME-Version: 1.0
In-Reply-To: <20090127210727.GA9592@us.ibm.com>
References: <4973AEEC.70504@gmail.com> <20090119175919.GA7476@us.ibm.com>
	 <20090126223350.610b0283.akpm@linux-foundation.org>
	 <20090127210727.GA9592@us.ibm.com>
Date: Fri, 27 Feb 2009 15:56:40 +0100
Message-ID: <25e057c00902270656x1781d04er5703058e47df455f@mail.gmail.com>
Subject: Re: [PATCH] mm: get_nid_for_pfn() returns int
From: roel kluin <roel.kluin@gmail.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       y-goto@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > get_nid_for_pfn() returns int

>> > My mistake.  Good catch.

>> Presumably the (nid < 0) case has never happened.
>
> We do know that it is happening on one system while creating
> a symlink for a memory section so it should also happen on
> the same system if unregister_mem_sect_under_nodes() were
> called to remove the same symlink.
>
> The test was actually added in response to a problem with an
> earlier version reported by Yasunori Goto where one or more
> of the leading pages of a memory section on the 2nd node of
> one of his systems was uninitialized because I believe they
> coincided with a memory hole.  The earlier version did not
> ignore uninitialized pages and determined the nid by considering
> only the 1st page of each memory section.  This caused the
> symlink to the 1st memory section on the 2nd node to be
> incorrectly created in /sys/devices/system/node/node0 instead
> of /sys/devices/system/node/node1.  The problem was fixed by
> adding the test to skip over uninitialized pages.
>
> I suspect we have not seen any reports of the non-removal
> of a symlink due to the incorrect declaration of the nid
> variable in unregister_mem_sect_under_nodes() because
>  - systems where a memory section could have an uninitialized
>    range of leading pages are probably rare.
>  - memory remove is probably not done very frequently on the
>    systems that are capable of demonstrating the problem.
>  - lingering symlink(s) that should have been removed may
>    have simply gone unnoticed.
>>
>> Should we retain the test?
>
> Yes.
>
>>
>> Is silently skipping the node in that case desirable behaviour?
>
> It actually silently skips pages (not nodes) in it's quest
> for valid nids for all the nodes that the memory section scans.
> This is definitely desirable.
>
> I hope this answers your questions.

This still isn't applied, was it lost?

Roel
