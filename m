Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYFSAti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYFSAti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYFSAtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:49:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:30377 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbYFSAtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=So2gkWVo41qNM5Cmf7ssByj3mdIJw0ofQL/2KVHSjsDSCwjA8jjDst6nMr2pg/JMOQ
         dG10sm10tNVgN3iPkO6zYUoIE767sQG8XHDBY6iljpap073HmomCsqzyJiykftCQVUun
         SsAVQfkZHq3KVhgKrHRhdOHyk6V4vLnrJUuTk=
Message-ID: <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
Date: Wed, 18 Jun 2008 17:49:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200805191252.36814.yhlu.kernel@gmail.com>
	 <200805251600.26325.yhlu.kernel@gmail.com>
	 <200806011317.38622.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
	 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
	 <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 5:33 PM, Len Brown <lenb@kernel.org> wrote:
>
>
> On Wed, 18 Jun 2008, Yinghai Lu wrote:
>
>> On Wed, Jun 18, 2008 at 3:18 PM, Len Brown <lenb@kernel.org> wrote:
>> >
>> >
>> > On Sun, 1 Jun 2008, Yinghai Lu wrote:
>> >
>> >>
>> >> make mptable to be consistent to acpi routing, so we could
>> >> 1. kexec kernel with acpi=off
>> >> 2. workaround BIOS that acpi routing is working, but mptable is not right.
>> >>    so can use kernel/kexec to start other os that doesn't have good acpi support
>> >
>> > Is this an effort to boot an ACPI-mode kernel,
>> > and then kexec a non-ACPI kernel?
>>
>> Yes,
>
> Why is this feature needed?
> There are a number of ways that the resulting kernel may fail,
> all platform specific.

other os still doesn't have update acpi irq routing support. but has
broken mptable.

>
>> >
>> > Doing so could confuse the heck out of the platform firmware,
>> > which will think that an ACPI-mode kernel is still running.
>> >
>> > Note that it is a historic artifact, now considered a bug,
>> > that ACPI uses the MPS code.  We should be divorcing these
>> > two bodies of code rather than mixing them further.
>>
>> how about adding config option to not compile mptable related info?
>
> That's the idea.
> CONFIG_MPS=n CONFIG_ACPI=y should build and run on
> every PC built in this century.
>
> This was prototyped a long while back, but the
> tree has churned so much since then the old
> prototype is worthless.

will look at it tonight.

when EFI is popular, there is no reason to compile mps related stuff
in kernel again. esp for 64 bit.

BTW, it is funny that Suse still has fallsafe boot entry with acpi=off.

YH
