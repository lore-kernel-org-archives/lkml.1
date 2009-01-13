Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbZAMN2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbZAMN2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbZAMN15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:27:57 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:42737 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbZAMN1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:27:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ekCoCAlZdLL/wOEKoZHCElaj0IC55WMrD/O9Vk+1nANO2tCb+KSM/XYolpC4ruETt9
         TTYCPTnx6+PkW2/itpAUBZxdK3oNuxIktXBnmmQLfKoCW3q9X9w6TyTk3X31J2OH1ijJ
         +HKLyttJQPRNvwdjt9sOVZqz+8mX22Saf6I3w=
Message-ID: <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>
Date: Tue, 13 Jan 2009 08:27:52 -0500
From: "Brian Gerst" <brgerst@gmail.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [PATCHSET linux-2.6-x86:tip] x86: make percpu offsets zero-based on SMP
Cc: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
In-Reply-To: <496C717F.70204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
	 <496C717F.70204@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 5:48 AM, Tejun Heo <tj@kernel.org> wrote:
> Tejun Heo wrote:
>> Each step was tested with gcc-4.1.3, 4.2.3 and 4.3.1 on x86_64, 4.3.1
>> on i386 for both SMP and UP configurations.  The final state is
>> currently being tested using 4.2.3 on both x86_64 and 32.
>
> Aieee.. two sentences mixed up in my head.  Correction:
>
> Each step was tested with gcc-4.3.1 for both x86_64 and 32.  The final
> step for x86_64 has been tested with gcc-4.1.3, 4.2.3 and 4.3.1.
> Currently, I'm burn-testing both x86_64 and 32 using gcc-4.2.3 with
> all patches applied.
>
> Thanks.

I've been working on a patchset that does something similar, but
eliminating the PDA completely.  The start is already in tip/x86/pda.
The plan is to change all PDA variables to be normal per-cpu
variables, merging with 32-bit where possible.  Once the PDA is empty,
I'll base %gs at the start of the per-cpu area.  I've been working out
the bugs with the last patch (zero-basing the percpu area) before
submitting, but I probably won't have the time until this weekend to
polish it off.  I could submit all but the last patch if you'd like.
They are functionally correct, but because the per-cpu area isn't
zero-based yet the generated code is a bit bloated due to having to
calculate the delta for the %gs offset.

--
Brian Gerst
