Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbYFCEGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbYFCEGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYFCEG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:06:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:56670 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYFCEG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:06:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aMPl0qBa2M58Hy3EWyjscg95D9HZvXPDSRGu5iln+v/e0kdXBO3gDTd0gJnr7zMxyzL6zckliRAXqlNN9Zy/90RCMiDyofOR31KNPs0PfzLHumGR6uPEI8P1Yd9nA8GcKl2KyWqD/Zgin2R73L6AOPRSdbsirXHt3Sf4Rwnc+4Q=
Message-ID: <19f34abd0806022106v47b1e139qcd012335e867261e@mail.gmail.com>
Date: Tue, 3 Jun 2008 06:06:27 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Pavel Emelyanov" <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <m1fxrv18q2.fsf@x61.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
	 <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
	 <m163srxoq5.fsf@frodo.ebiederm.org>
	 <20080602191016.85ce404b.akpm@linux-foundation.org>
	 <m1fxrv18q2.fsf@x61.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 5:46 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
>>>  #ifdef CONFIG_SECURITY
>>>      inode->i_nlink += 1;
>>>  #endif
>>> +#ifdef CONFIG_NET
>>> +    inode->i_nlink += 1;
>>> +#endif
>>>
>>>      dentry->d_op = &pid_dentry_operations;
>>
>> A bit more explanation would be nice.
>>
>> I assume that here we're accounting for a reference which net applies
>> to this dentry.  But it would be clearer and more robust to do that at
>> the site where that reference is really taken, not over in
>> proc_pid_instantiate().  Possible?
>
> Yes.  Potentially we can read through the tid_base_stuff and
> count the total number of directories at runtime whenever we
> open a /proc/<pid> directory.  It is a smallish table and walking the
> entire table is likely to be lost in the noise, and that would
> certainly improve the maintainability of the code.
>
> Currently what we do is:
>        inode->i_nlink = 5;
> #ifdef CONFIG_SECURITY
>        inode->i_nlink += 1;
> #endif
>
> To get the hard link count of /proc/<pid> correct.
> With /proc/<pid>/net we have added one more optional possibly absent
> directory.
>
> So the above patch is trivially correct in the current form of the
> code but does not improve maintenance.
>
> I am tired and all I have the energy to do today is to review the
> patch and say: "Yes.  The patch works for the correct reasons, let's
> fix this bug."

I can try for the counting fix if you give me a bit of time. I have an
exam today and tomorrow, so I'll likely be able to submit a fix after
that :-)

Maybe you can apply the fix for now and I can follow up with the nicer
counting patch afterwards? (Or if anybody else wants to write it
that's also fine :-))


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
