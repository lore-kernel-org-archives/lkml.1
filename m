Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZJVKkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZJVKkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZJVKkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:40:09 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49865 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZJVKkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:40:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=cKlr/0xQmbhZg84ABBOehF2fBz2aonUkwnLBKeaTuub2Zm/c+4hZTBwTOg9BC99iwq
         XzZmJLD70yCphb7eS5NxOkD7ztL6QIlvfGy37+Fzh2SBQWwRyh+pRQYPBvNahg9Zr8LY
         wEenfCKJd1eZ1BI+9ZI01/mPwf++QnhRvtESM=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20091021194440.GA1283@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
	 <20091016042041.GA7220@us.ibm.com>
	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
	 <20091016180631.GA31036@us.ibm.com>
	 <20091019174405.GE27627@count0.beaverton.ibm.com>
	 <4ADCDAA8.5080408@zytor.com>
	 <20091019235012.GF27627@count0.beaverton.ibm.com>
	 <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>
	 <4ADF06B7.50508@zytor.com> <20091021194440.GA1283@us.ibm.com>
Date: Thu, 22 Oct 2009 12:40:10 +0200
Message-ID: <cfd18e0f0910220340n7c655daap78e395136c56f882@mail.gmail.com>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Helsley <matthltc@us.ibm.com>,
       randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev,

On Wed, Oct 21, 2009 at 9:44 PM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
> H. Peter Anvin [hpa@zytor.com] wrote:
>> On 10/21/2009 01:26 PM, Michael Kerrisk wrote:
>>>
>>> My question here is: what does "3" actually mean? In general, system
>>> calls have not followed any convention of numbering to indicate
>>> successive versions -- clone2() being the one possible exception that
>>> I know of.
>>>
>>
>> "3" is number of arguments.
>
> To me, it is a version number.

See my precending mail. Isn't the number of arguments "2".

> mmap() and mmap2() both have 6 parameters.
>
> Besides if wait4() were born before wait3(), would it still be wait4() :-)
> But I see that it is hard to get one-convention-that-fits-all.

Yes -- that's exactly right.

>> It's better than "extended" or something
>> like that simply because "extended" just means "more than", and a number
>> at least tells you *how much more than*.
>
> And extended assumes we wont extend again.

Well, if we do things right in this design, we may not need to ever
extend (by creating a new syscall) again. That's why I mentioned the
"flags" argument idea. Did you give this some thought?

> An informal poll of reviewers has clone3() with a slight advantage :-)
>
>        clone_extended() camp: Serge Hallyn, Kerrisk, Louis Rilling,
>        clone3(): Sukadev, H. Peter Anvin, Oren, Matt Helsley.
>
> I like clone3() but am not insisting on it. I just want a name...

And I'm not really insisting on a change. As you rightly point out,
there is much inconsistency in the naming conventions that have been
used over the years.

But, because there has been no consistency in the use of numbers, and
because the number of arguments that are presented in a glibc
interface may differ from the number of arguments in an underlying
syscall (several precedents: signalfd4(), pselect(), ppoll()), I'm
inclined to think that clonex() or clone_ext() is slighly better than
clone3(). But, certainly, my arguments are not compelling.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
