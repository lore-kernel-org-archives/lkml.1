Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZIRLum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZIRLum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZIRLul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:50:41 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:33704 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbZIRLuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <20090918060210.GC7104@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> 
	<m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> 
	<ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> 
	<alpine.LFD.2.01.0909171322210.4950@localhost.localdomain> 
	<ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> 
	<alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> 
	<1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 18 Sep 2009 13:50:29 +0200
Message-ID: <ac3eb2510909180450x19e1272dq6f742f49bc56d4a2@mail.gmail.com>
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was: 
	Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster)
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 08:02, Greg KH <greg@kroah.com> wrote:
>> Here is a quick hack to allow subsystems to provide a mode for their
>> devices. It uses the callback that can provide custom non-default device
>> names. Ingo, maybe you can give it a try?
>>
>> To see how it works, it currently includes access to: null, zero, full,
>> random, urandom, tty, ptmx. Also the USB /dev nodes have the same
>> permissions as the USB /proc nodes always had. That's basically what
>> udev does today for non-root users.
>
> Ick, I don't think we should do something like this, it starts putting
> the mode policy back into the kernel.

Yeah, we should not go too far here. I don't mind having the few 0666
well-defined special nodes though.

>  What's next, owner and group?  :)

Udev does not set a owner ever I think, uid is always root. Group
name/number mapping is usually not known by the kernel, so we should
be safe here for the common systems. :)

The Android guys though have the group ids in the kernel as part of
their platform spec. They expressed interest to be able to manage all
this with their platform code. So we might just want to provide the
needed hooks for people with these very specific setups, to plug into
it.

> I think the udev version in older Fedora releases can't handle this
> kernel option, which is fine, just don't enable it.  Newer versions can
> handle it, right?

Yes, they should work fine. I guess even the old versions will run
fine, it's more that Ingo did not run any udev, I expect.

Kay
