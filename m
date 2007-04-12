Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXDLVNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXDLVNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXDLVNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:13:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:63400 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbXDLVNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Duzq4dENfPDmi5KdQhd53zVBydRpg9bST40JT6GC11HuVikFagOntknucLUYjIQNnEFdpwh9HkXT4rvHxMJQboeLe242MUZBp9ZErVd4PYvi3Du+AtPErBt7HRMP4A9iCUuyEPBs2IMGyiyz6whptVgbdwMOOYo9NsyYbIYYO/M=
Message-ID: <a781481a0704121413o332a3734teebecfb7272c6cad@mail.gmail.com>
Date: Fri, 13 Apr 2007 02:43:05 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Cc: "Tasos Parisinos" <t.parisinos@sciensis.com>,
       "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
In-Reply-To: <2293.81.207.0.53.1176410694.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4610D25F.7080005@ceid.upatras.gr>
	 <000401c77cdd$5ef79910$0864a8c0@scs1>
	 <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
	 <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
	 <a781481a0704120720y5772cd56y75fff466551a2fda@mail.gmail.com>
	 <3785.81.207.0.53.1176390072.squirrel@secure.samage.net>
	 <a781481a0704121138x2ecfa5b0lb791dc5680f08515@mail.gmail.com>
	 <1574.81.207.0.53.1176404759.squirrel@secure.samage.net>
	 <a781481a0704121257v19c82552gac7f60784c7bafa@mail.gmail.com>
	 <2293.81.207.0.53.1176410694.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/07, Indan Zupancic <indan@nul.nu> wrote:
> On Thu, April 12, 2007 21:57, Satyam Sharma wrote:
> > Of course, I'd rather code to the PKCS#1 RSA Cryptography Standard
> > than an entry-level Wikipedia page :-) Timing attacks are particularly
> > problematic on smart cards (too slow, and with predictable operation
> > times, if not using constant-time crypto implementations) and not
> > really worthwhile in practice on any other platform where there's
> > enough noise around to make accurate timing difficult
>
> Noise can be filtered out, and combined attacks can give enough information.
> (E.g. throw in power usage or other measurements.) There are ways to add
> noise to the timing, but still using those optimisations. The point was
> that they add extra code and complexity.
>
> (Personally I think RSA-like asymmetric encryption has so many, often
> subtle problems, with complex, hard to get secure implementations, that
> it's something I'd avoid using as much as possible. Unfortunately there's
> not much alternative.)

But timing attacks are not exclusive to RSA / asymmetric
cryptosystems. Such (side channel / timing / power measurement / bus
access) attacks are possible against AES, etc too.

Of course, now we're really moving into a different realm -- I guess
in security there is always a threshold, and you really needn't care
beyond a particular threat perception level. I don't see how even the
existing cryptoapi (or *any* security measure in the kernel for that
matter) stands up to the kind of attacks we're talking about now.

> > constant-time crypto implementations do take care of
> > them, though I agree the GPG code too lacks that.
>
> That's because for side-channel attacks you need physical access to the
> hardware, something for most machines means security is breached anyway.
> But when this code is going to be used to sign things by embedded devices
> (with a local, secret key), it can be important.
>
> For checking signatures the key is known and all this doesn't matter, but
> we're talking about a common implementation. It are things to keep in mind.

I think the original idea was to generate signatures at a centralized
place (not on an embedded system) and only *verify* them using
*public* keys on the embedded systems? For most common
implementations, as I suggested, you only need bother yourself upto a
certain security threshold.
