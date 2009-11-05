Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZKEVPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZKEVPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 16:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbZKEVPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 16:15:24 -0500
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:32183 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758592AbZKEVPX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 16:15:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GaWhu7ws4948PPKp3LXwzMOSchwWAZX7YiUK0glCGmZB6jUqTKvC4zjbEnx/lr2PkpwcNW9muhokEepdjw2R0nsmO6Jidl/hBTxjn68iE49lSBZubJtdKDRhdC1Cf66mudSc+RpRjmONYqwsrBG2uTgezhMAMwmtn8JsDRFxQFk=;
Message-ID: <797900.98239.qm@web50101.mail.re2.yahoo.com>
X-YMail-OSG: t6CjQscVM1lc64JVndNCyFh7BuWB4rhblQGGlfVy7wCb_Fxxh0dP.u2d7R8QfNPZk.4L24XCRXxmBlEYp3skJkB.qg9ZQiLJNNUAYmNUj75vS8RiqqNUFieK8U4VSLzilyxjAXkKeNCJqfsMgfbNxstD8VQ0oAK8wwb39wQcvU9IuvKtd8MehG1ep30Xjlp4j.R6iLt6U.sRAfjm.kVwzmFkIbwri8tmUhms9k2og1aHcjJe6Q5aTAi.U01Et4V.4DS4_wPMXp6g62IABcl7Dn9.0l.YlS8ivutM671P1OaH6_wD16wxXqVwBRmVO6mJcvf22FnuF0j_1UPDjxHKmuA9z8gXo27mqRBS22Sb9xNpMVt9OVf7PUk8d1pQ7RP1EqcBtcPDsxOBIQQarVJ7dDI.k2aLzfw9lz44p9mhahrBc7t1ol7Vge6feHcuWRMMpb2PJZLbKxa8vfAyMLEf5a4RXBr1vLyW
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.7.361.4
Date: Thu, 5 Nov 2009 13:15:28 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC] amd64_edac: syndromes loading
To: "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86 <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091105132758.GC17984@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 11/5/09, Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Subject: Re: [RFC] amd64_edac: syndromes loading
> To: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Pavel Machek" <pavel@ucw.cz>, "Doug Thompson" <norsk5@yahoo.com>, "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>, "x86" <x86@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
> Date: Thursday, November 5, 2009, 6:27 AM
> Hi,
> 
> The good news is they've come up with a modified algorithm
> which will
> require a smaller table, roughly 1/4th the size of the
> current 10K one.
> Now, on a second thought and IMHO, we should simply add
> another .c file
> instantiating those two x4 and x8 tables statically and
> linking them
> into the edac code. This way you
> 
> 1) don't have the additional complexity of adding firmware
> handling code
> and thus don't add a dependency on the firmware API
> 
> 2) don't have to actually carry two firmware images with
> the kernel
> 
> See, the natural use case for those tables are big machines
> which do not
> care about 4K memory wasted in ECC decoding tables when the
> recovery
> from the missed early warnings of a failing DIMM module is
> much more
> expensive.

very well put.  when nodes that have 64 or 128 GIGA-bytes of RAM are involved, 4k or even 32kb "loss" is in the noise.

Features vs costs is always something to weigh. In some cases loss of 4k in a 1 Gb machine might not be tolerated (though I accept it).

doug t

> 
> Hmm... ?
> 
> -- 
> Regards/Gruss,
> Boris.
> 
> Operating | Advanced Micro Devices GmbH
>   System  | Karl-Hammerschmidt-Str. 34, 85609
> Dornach b. München, Germany
>  Research | Geschäftsführer: Andrew Bowd, Thomas M.
> McCoy, Giuliano Meroni
>   Center  | Sitz: Dornach, Gemeinde Aschheim,
> Landkreis München
>   (OSRC)  | Registergericht München, HRB Nr.
> 43632
> 
> 
