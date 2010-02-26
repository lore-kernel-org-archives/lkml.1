Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935697Ab0BZJ0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:26:44 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37426 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682Ab0BZJ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:26:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Hitt9AA9tZORuAL/n1b+qcZjqhtDTZJsG2o5mAwl/vdHLM4VXO7vSFKwa6BQVtvgsG
         baJ18kqN4ri1LeBQV5kDhLsXLbZ0nmKlCnuFdXCrLBuJsbhGsF0B+beuNgx7w3QH5GYy
         pr45nVxvQm6Cek6ePDEsuatFN4ntISmVBVwWM=
MIME-Version: 1.0
In-Reply-To: <201002252104.51187.rjw@sisk.pl>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
	 <201002242152.55408.rjw@sisk.pl>
	 <9b2b86521002250510m75c8b314o37388a04b53a2b67@mail.gmail.com>
	 <201002252104.51187.rjw@sisk.pl>
Date: Fri, 26 Feb 2010 09:26:37 +0000
Message-ID: <9b2b86521002260126g5acabb79uae961dd8668b3c09@mail.gmail.com>
Subject: Re: s2disk hang update
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mel@csn.ul.ie>, hugh.dickins@tiscali.co.uk,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 25 February 2010, Alan Jenkins wrote:
>> On 2/24/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Wednesday 24 February 2010, Alan Jenkins wrote:
> ...
>>
>> > -	while (to_free_normal > 0 && to_free_highmem > 0) {
>> > +	while (to_free_normal > 0 || to_free_highmem > 0) {
>>
>> Yes, that seems to do it.  No more hangs so far (and I can still
>> reproduce the hang with too many applications if I un-apply the
>> patch).
>
> OK, great.  Is this with or without the NOIO-enforcing patch?

With.

>> I did see a non-fatal allocation failure though, so I'm still not sure
>> that the current implementation is strictly correct.
>>
>> This is without the patch to increase "to_free_normal".  If I get the
>> allocation failure again, should I try testing the "free 20% extra"
>> patch?
>
> Either that or try to increase SPARE_PAGES.  That should actually work with
> the last patch applied. :-)
>
> Rafael

<grin>, OK.
