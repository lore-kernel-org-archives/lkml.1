Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZENSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZENSnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 14:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZENSnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 14:43:11 -0400
Received: from web50103.mail.re2.yahoo.com ([206.190.38.31]:47310 "HELO
	web50103.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750957AbZENSnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 14:43:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=KCShlQNwIjwGvJ2KHFyHe89xVcZvL7r2ouQcqbaEO3jB8ncQYmEq5ENJ2QJ9CGfkTsPsFT/XoclgSsDY1HSo/DtUASCA0QstxVma6xOvNMFTw6LvLVSD0FNAkYb4AP63TYrQ/fxXmEr9Vg95LML25kXStLX0mI07l0YA3woMCyM=;
Message-ID: <391836.21526.qm@web50103.mail.re2.yahoo.com>
X-YMail-OSG: JvbDKW8VM1nLEpjsvPxBGA.DmTCkrx0I57pDGd1DmNCioNbJPLB5ZB3iSTaJ4WypcG77GRFSSvw3XZVXpizENNmmhvfHb4HiD6xdd2V0HKDZ5512.pc6tEsHOkaVQSQ5uMH6tJTnPfR9OCUiAukxDERWtypFS90utTcDVXa8oDrWQU.BN6m5gDgDobIzuJin1Qj8lwWNpW_oYYyRjJwXJPceFR8.UQQ7teDKh0Fn.D6JNu0RVGyMlT_Zex9fBipUu6_nZu2Q.GMzTpYITqPxe06ffFz9MCH4_Iu8YrZ.kFVK.PeG3b7PIQ--
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com> <1241704183-29223-22-git-send-email-borislav.petkov@amd.com> <20090507215815.GB28770@elte.hu> <20090514175205.GB8575@aftab>
Date: Thu, 14 May 2009 11:43:11 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 21/21] amd64_edac: add module registration routines
To: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de,
       hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>
In-Reply-To: <20090514175205.GB8575@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---- Original Message ----

From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org; greg@kroah.com; norsk5@yahoo.com; tglx@linutronix.de; hpa@zytor.com; mchehab@redhat.com; aris@redhat.com; edt@aei.ca; linux-kernel@vger.kernel.org; Doug Thompson <dougthompson@xmission.com>
Sent: Thursday, May 14, 2009 10:52:05 AM
Subject: Re: [PATCH 21/21] amd64_edac: add module registration routines


> > +      Recent Opterons (Family 10h and later) provide for Memory Error
> > +      Injection into the ECC detection circuits. The amd64_edac module
> > +      allows the operator/user to inject Uncorrectable and Correctable
> > +      errors into DRAM.
> > +
> > +      When enabled, in each of the respective memory controller directories
> > +      (/sys/devices/system/edac/mc/mcX), there are 3 input files:
> > +
> > +      - z_inject_section (0..3, 16-byte section of 64-byte cacheline),
> > +      - z_inject_word (0..8, 16-bit word of 16-byte section),
> > +      - z_inject_bit_map (hex bitmap vector: mask bits of 16 bit word to
> > +        error-out)
> > +
> > +      In addition, there are two control files, z_inject_read and
> > +      z_inject_write, which trigger the Read and Write errors respectively.
> 
> I think the file names should follow existing EDAC driver practices, 
> and be named according to the existing inject_data_* pattern?
> 
> There's nothing more annoying to users (and tools) than inconsistent 
> driver namespaces.

Agreed. Done.

@Doug: edac-utils doesn't use those yet, right?

[..]


No, and probably won't.  Those injection semantics are specific to the AMD64 only

I have only done one other inject implementation with Sicortex's MIPS processors
and these two do not provide enough to generate an abstract interface quite yet.
Hence, it is driver SPECIFIC methods at this time

doug t
