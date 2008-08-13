Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYHMLId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYHMLId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYHMLIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:08:23 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:63020 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbYHMLIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mnISAneXGphDnHxhJEE5CS+8lvpCPuNz3bnucSO4ZSPk4ReZ0nY5Dl6suB8kdUSi/g
         LlHUO1YyC1s2Yd0NVPRzyYZfEbwHY4n1LJDq2+mScUj6M62eM2w4C2MwBmGIfaYErHur
         9KN/iG0OLoFXNzVtedNeUcwqMqCThCWLUzt5A=
Message-ID: <e7d8f83e0808130408q1a1a4d27occ265902a16cbc5@mail.gmail.com>
Date: Wed, 13 Aug 2008 21:08:20 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Cc: "Pavel Machek" <pavel@suse.cz>, davecb@sun.com,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>,
       "Adrian Bunk" <bunk@kernel.org>, tvrtko.ursulin@sophos.com,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BA4@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806105008.GF6477@cs181140183.pp.htv.fi>
	 <200808070349.55882.mdontu@bitdefender.com>
	 <20080806213904.37a33a58@infradead.org>
	 <200808111645.48177.mdontu@bitdefender.com>
	 <20080811065608.44687f65@infradead.org> <48A0649B.4010706@sun.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com>
	 <20080813102802.GC27074@atrey.karlin.mff.cuni.cz>
	 <2629CC4E1D22A64593B02C43E855530304AE4BA4@USILMS12.ca.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 8:46 PM, Press, Jonathan <Jonathan.Press@ca.com> wrote:
>> -----Original Message-----
>> From: Pavel Machek [mailto:pavel@suse.cz]
>> Sent: Wednesday, August 13, 2008 6:28 AM
>> To: Press, Jonathan
>> Cc: davecb@sun.com; Arjan van de Ven; Mihai Don??u; Adrian Bunk;
>> tvrtko.ursulin@sophos.com; Greg KH; linux-kernel@vger.kernel.org;
> linux-security-
>> module@vger.kernel.org; malware-list@lists.printk.net
>> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
> linuxinterfaceforon access
>> scanning
>>
>> > I think everyone understands one side of the threat model, that is
> Linux machines
>> being carriers of infections aimed at other platforms.  There are many
> ways that
>> such infections can be stored, and many ways in which they can be
> communicated
>> to the target machines.  There are so many that it would not be
> effective or efficient
>> for each such transfer application to be able to handle its own
> malware scanning,
>> which is the short statement of why centralized AV protection with
> notification
>> assistance from the kernel is appropriate.
>> >
>>
>> No.
>>
>> Proposed kernel solution did not work -- there still was write
>> vs. read race. You are right that it is not ok for each application to
>> do its own malware scanning, but libmalware.so that handles the
>> scanning seems very reasonable.
>>
>> And as applications _need_ to be modified for the write vs. read race
>> to be solved, libmalware.so looks like a way forward.
>>
> Pavel
>
> I am not sure what you are suggesting, and I may have missed the
> libmalware proposal (I don't see any mention of that specific idea in
> any other message).  However, just to be clear...  At no point did we
> suggest that the kernel would do any scanning.  What we have been
> interested in is a mechanism that can allow a scanning application to be
> notified by the kernel of specific i/o events, for those events to be
> blocked by the kernel until a user-space scan is done, and then the
> user-space scan sends back allow or deny, at which point the i/o event
> returns to the caller -- either success or error.  This is the only way
> that malware can be guaranteed of being detected when it is used (for
> local application purposes or for transmission to another platform) or
> created.
>
> Also, a solution that requires applications to be modified will not
> work, because there is no way that we would be able to get ALL
> applications on the machines to be modified in the required ways.  If
> ANY applications are not so modified, then you have an unacceptable
> malware hole.  The only solution that really works is one that
> guarantees that all applications are involved, which is why the kernel
> has to be involved in some way.  It's the only centralized authority
> that can stick its nose into all of the required activities.
>
> Whether the specific proposal currently on the table handles all the
> issues or not is to me a separate point.

Being in the correct place is key.   Wrong place more issues more holes.

Lets get this right this time please.  Windows is a mess.   You cannot
run many av products side by side.    Due to failures of signatures at
times to pickup every threat out there we have to move forward with a
system that works.  Supporting many scanners at once if needed.

LIM guys are going after the same kind of defect detection.

Lot of designs have been created over all the years but they have all
failed to address the basics.

Scanning without file caching leaves a hole and costs cpu time.  So
integration into the file system cache system is kinda key.

Designing hooks forcing users to use only 1 product.   Yes good for
market lock in but kicks lots people in teeth.

Getting patch mainline is basically going to hit walls if you don't
sit down and say lets fix the kernel secuirty correctly.   This is not
windows you have the power to alter the complete kernel if you can
provide valid justification for the change.

Valid justification is that someone like me looks at it and cannot
find a flaw in design and it provides needed functionality.  Issue you
keep on addressing only 1 this is the reason why the patches have
stayed out side mainline when other patches have got in.   In theory
the complete core of the Linux kernel could be replaced if Valid
justification could be made.

This is where Linux is different to Windows.   You are free to
redesign linux to be the hardest OS on earth for a virus to operate.
Where windows you have to work with provided model.   Lots here need
to drop the idea that anything in the Linux kernel is set in stone.
Only thing set in stone flawed designed get shot down.

Lets start with what would the features you would wish for as
Anti-virus designers if you could design a OS from scratch around your
Anti-virus so it was almost flawless.   From that list we have what we
need to work on to give you exactly what you want in time.   Even
better post that on a long term website as a wishlist for all OS's.
Basically give us direction.

Peter Dolding
