Return-Path: <linux-kernel-owner+w=401wt.eu-S934732AbZARSVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934732AbZARSVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZARSV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:21:27 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:56696 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZARSV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MItK4CAeD5NH9WSab4S1v4yf9G7X+nfM3m6KfLdiJLbxWAZk6Kxk5bat7Ab5o+nwSU
         ERFkNY/SjePFnQ/2G8PE3942/S7wvu96eP0h5OXAENTY79lscd/XHZk8qMr/l0LcQSW/
         DffucH15erjjT7Td+5CDJauft8SkYAcKUf31g=
MIME-Version: 1.0
In-Reply-To: <1232301872.3247.23.camel@localhost.localdomain>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
	 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
	 <4972B8AB.8040001@kernel.org>
	 <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com>
	 <4972C53C.5050509@kernel.org>
	 <73c1f2160901172251t34e824ecue6323ce04fc494e9@mail.gmail.com>
	 <20090118071427.GA29613@elte.hu>
	 <1232296885.3247.17.camel@localhost.localdomain>
	 <73c1f2160901180941o5ffceaeq3455483cd40fa45f@mail.gmail.com>
	 <1232301872.3247.23.camel@localhost.localdomain>
Date: Sun, 18 Jan 2009 13:21:25 -0500
Message-ID: <73c1f2160901181021i6078b1b7ta2980e6fa41b4193@mail.gmail.com>
Subject: Re: x86/Voyager
From: Brian Gerst <brgerst@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 1:04 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sun, 2009-01-18 at 12:41 -0500, Brian Gerst wrote:
>> On Sun, Jan 18, 2009 at 11:41 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Sun, 2009-01-18 at 08:14 +0100, Ingo Molnar wrote:
>> >> If there's no time/interest in that then we can temporarily mark Voyager
>> >> CONFIG_BROKEN until cleanup/fix patches arrive.
>> >
>> > It's not broken and I've already sent you the cleanup/fix patches ... I
>> > can send them directly to Linus as voyager maintainer if you prefer.
>>
>> The build breakage was due to the cpumask changes I believe, inherited
>> from -tip.
>>
>> There is alot of duplicated code in voyager_smp.c that is making it
>> difficult for me to work on the per-cpu changes.
>
> Actually, there's very little duplicated code, but what there is we can
> unify.  The reason it duplicates the API is because it has to provide a
> different implementation for voyager ... it's not a PC x86 architecture.
>
>>   Do you see any
>> reason that Voyager can't use the normal x86 setup_per_cpu_areas()
>> code?
>
> Er, well, yes.  Current setup_per_cpu_areas is setting up the cpu<->apic
> maps.  Voyager has no apics, so it has no use for any of the arrays
> being set up in there.
>
> If you're proposing to add arrays that would actually be useful to
> voyager, then sure we can use it ... it's just at the moment there's no
> need.   What is it you want to add in there?

The apic code can be ifdef'ed out for voyager.  The reason I want to
use the x86 setup_per_cpu_areas() is that I want to consolidate
initializing per-cpu variables in one place.  Voyager currently has
sprinkled in various places setting this_cpu_off, cpu_number, etc.

--
Brian Gerst
