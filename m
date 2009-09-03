Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZICSA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZICSA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZICSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:00:25 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:53516 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZICSAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Pi0YijXxPjaG5ELDnkDWlQttw4KM6Wxmkd3JHEXatLOYK582OuLqu2VuU2nbwjKwLE
         KB8lT6RJAFpduFpdmUhiHwC0i4s+eNdHsxdx+/cyZSmePPB3zhEtDm7EOtOLjFsIW/+7
         O4W/4/cywZsWZ79cFl09BAvOdv/6AzZ429LVE=
MIME-Version: 1.0
In-Reply-To: <1251984845.3336.25.camel@johannes.local>
References: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com> 
	<84144f020909022323na828156v4eb9a8497cadaef8@mail.gmail.com> 
	<1251983939.22485.18.camel@pc1117.cambridge.arm.com> <1251984845.3336.25.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Sep 2009 11:00:07 -0700
Message-ID: <43e72e890909031100l5f28dd4cu30cf1e1c735e0e9d@mail.gmail.com>
Subject: Re: Exporting kmemleak.h to userspace
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 6:34 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-09-03 at 14:18 +0100, Catalin Marinas wrote:
>> On Thu, 2009-09-03 at 09:23 +0300, Pekka Enberg wrote:
>> > On Thu, Sep 3, 2009 at 3:29 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> > > I was reviewing kmemleak code and noticed kmemleak.h went exported to
>> > > userspace under include/linux/kmemleak.h. Do we expect userspace to
>> > > use this stuff somehow? All relevant kmemleak structs are kept
>> > > private, I'm curious what userspace apps would use this.
>> >
>> > AFAICT, nobody. Catalin, why is the header exported?
>>
>> I haven't done anything specifically to export it. It probably gets
>> included via other files. Is adding #ifdef __KERNEL__ enough to avoid
>> this problem?
>
> It should be exported only if it's listed in Kbuild,

What do you mean by that?

> which it isn't. Luis?

Well I see kmemleak on

Kernel hacking -->
[*] Kernel memory leak detector

but its not clear to me by what you mean by that it should be exported
only if its listed in Kbuild.

Anyway my point was that userspace does not need kmemleak.h and we are
providing it to userspace. Unfortunately I really am not sure what the
alternative is, it seems we tend to export to userspace a lot of other
kernel headers which userspace does not use. For networking we have
private header space for example on include/net/ but for general
kernel stuff is there an alternative? Should there be? Or as Catalin
mentions should we just use #ifdef __KERNEL__ for headers we do not
want to export to userspace?

  Luis
