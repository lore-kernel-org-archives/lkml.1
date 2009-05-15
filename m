Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbZEOXtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbZEOXtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 19:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZEOXtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 19:49:14 -0400
Received: from gw.goop.org ([64.81.55.164]:49660 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbZEOXtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 19:49:13 -0400
Message-ID: <4A0DFF78.6000501@goop.org>
Date: Fri, 15 May 2009 16:49:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>	<20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org>	<20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org>
In-Reply-To: <m1my9ex818.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> /proc/mtrr is in wide use today.  It may be planned for obsolescence, but
>> there's no way you can claim its obsolete today (my completely up-to-date F10 X
>> server is using it, for example).  We don't break oldish usermode ABIs in new
>> kernels.
>>     
>
> Sure it is.  There is a better newer replacement.  It is taking a while to
> get userspace transitioned but that is different.  Honestly I am puzzled
> why that it but whatever.
>   

There's no mention in feature-removal-schedule.txt.

>> Besides, the MTRR code is also a kernel-internal API, used by DRM and other
>> drivers to configure the system MTRR state.  Those drivers will either perform
>> badly or outright fail if they can't set the appropriate cachability properties.
>> That is not obsolete in any way.
>>     
>
> There are about 5 of them so let's fix them.
>   

Well, I count at least 30+, but anyway.

> With PAT we are in a much better position both for portability and for
> flexibility.
>   

PAT is relatively recent, and even more recently bug-free.  There are 
many people with processors which can't or won't do PAT; what's the plan 
to support them?  Just hit them with a performance regression?  Or wrap 
MTRR in some other API?

> Is it possible to fix PAT and get that working first.   That is very definitely
> the preferend API.
>   

Sure, when available.  We're sorting out the details for Xen, but even 
then it may not be available, either because we're running on an old 
version of Xen, or because some other guest is using PAT differently.

But I honestly don't understand the hostility towards 120 lines of code 
to make an interface (albeit legacy/deprecated/whatever) behave in an 
expected way.

    J
