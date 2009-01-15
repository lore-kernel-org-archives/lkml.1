Return-Path: <linux-kernel-owner+w=401wt.eu-S1765840AbZAOOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765840AbZAOOhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbZAOOhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:37:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:34681 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbZAOOhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:37:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dTuXxI1TZZNoZNgrP91eCGm53hEn/sjKA4/6nv4Y/rl7WnE51ICYxU4FFeURnvSwco
         XiBchHk7XiM72nos7iP2xgpml+uk1f1a6FTI7siW/X8hitETjBit2lOOpkoBNxJ7dddP
         af5aMHZm8/WH7h4JV4P/6eqUaEmnFGKba/TkI=
Message-ID: <195c7a900901150637r4a8d374dhe00ac47592c9c0d3@mail.gmail.com>
Date: Thu, 15 Jan 2009 15:37:12 +0100
From: "Bastien ROUCARIES" <roucaries.bastien@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Jiri Kosina" <jkosina@suse.cz>, "Adam Osuchowski" <adwol@zonk.pl>,
       linux-kernel@vger.kernel.org, "Nick Piggin" <npiggin@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
In-Reply-To: <20090115142047.GV11087@lug-owl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1231424025.11687.447.camel@twins>
	 <1231424833.11687.452.camel@twins>
	 <20090108150448.2393aeb0@lxorguk.ukuu.org.uk>
	 <20090108151046.GK18120@elte.hu>
	 <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org>
	 <20090115123614.GR11087@lug-owl.de>
	 <alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org>
	 <20090115133252.28c36adb@lxorguk.ukuu.org.uk>
	 <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org>
	 <20090115142047.GV11087@lug-owl.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 3:20 PM, Jan-Benedict Glaw <jbglaw@lug-owl.de> wrote:
> On Thu, 2009-01-15 14:15:56 +0000, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>> On Thu, 15 Jan 2009, Alan Cox wrote:
>> > >  UP emulation of CMPXCHG and XADD for userland should be rather trivial,
>> > > so why not include it like with LL/SC for MIPS?
>> >
>> > Why not just ship an additional libc with the right options ?
>>
>>  Does not work for MIPS as glibc has no equivalent code for pre-LL/SC CPUs
>> and LL/SC is always used.  For the i386 the situation seems worse yet as
>> for pre-i486 CPUs a generic C implementation of compare-and-exchange is
>> used guaranteeing silent thread unsafety. :(
>>
>>  IMO, a kernel emulation of CMPXCHG and XADD (both are used by
>> sysdeps/i386/i486/bits/atomic.h in glibc) with an optional LOCK prefix,
>> guaranteeing UP atomicity would be a cheap way to provide long-term i386
>> userland support with little burden for both Linux and respective user
>> software maintainers.  Certainly it adds some bloat to the kernel, but I
>> think it is not an option that should be outright dismissed without
>> consideration.
>
> I just searched for the old patch, but couldn't find it ad hoc. (But
> it must be somewhere, at least in the archives, I guess?)

here http://thread.gmane.org/gmane.linux.kernel/205839, but should be
securized (use get_user() )

Regards

> The kernel emulator has the benefit of no overhead when not switched
> on, and low-to-no overhead when not being used (i386 capable kernel on
> i486 hardware).
>
> Heck, I'd dig out my two test systems and give them a try with current
> Debian unstable. Should be fun with four to eight megabytes of RAM.
>
> MfG, JBG
>
> --
>      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
> Signature of: 23:53 <@jbglaw> So, ich kletter' jetzt mal ins Bett.
> the second  : 23:57 <@jever2> .oO( kletter ..., hat er noch Gitter vorm Bett, wie früher meine Kinder?)
>              00:00 <@jbglaw> jever2: *patsch*
>              00:01 <@jever2> *aua*, wofür, Gedanken sind frei!
>              00:02 <@jbglaw> Nee, freie Gedanken, die sind seit 1984 doch aus!
>              00:03 <@jever2> 1984? ich bin erst seit 1985 verheiratet!
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
>
> iD8DBQFJb0Y/Hb1edYOZ4bsRAnEeAJ9JkaqmDFOGp1uPNzBe4qeSgl19dQCeI123
> c4oTq/pPCaUPcdJp3a/GsbU=
> =wHyn
> -----END PGP SIGNATURE-----
>
>
