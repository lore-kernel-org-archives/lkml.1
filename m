Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZDWVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZDWVWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZDWVWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:22:06 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:55962 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZDWVWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ErNb8SI6p6tn4EvYeWzXN6ALI2IYQCrF/KSDY0Z6y03rDDppXaPniHNMd4Wrg7WeSd
         Yw/jX5iySHqFbdKkWOkGCBgm7JFE52cbJp3tOpx9UnweBRvNLV8IRgVfLRIssBUj+t+I
         QM+OLKz/pLdQfqTtAfHPUztQAvmfzIo9uXLXE=
MIME-Version: 1.0
In-Reply-To: <49EFC8FE.7010403@zytor.com>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu>
	 <8763gxoz50.fsf_-_@basil.nowhere.org>
	 <3605561d0904221649n169dc579xb0694297154d97fa@mail.gmail.com>
	 <49EFC8FE.7010403@zytor.com>
Date: Thu, 23 Apr 2009 14:22:02 -0700
Message-ID: <3605561d0904231422s57bd4cedl722be1dabf27428f@mail.gmail.com>
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: 
	New x86 warning
From: Joe Damato <ice799@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 6:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Joe Damato wrote:
>>
>> I think this patch is great. Perhaps this would be a good time to also
>> clean out memset for x86_32? (If needed, I can start a new email
>> thread with this patch) I've built and booted this on my x86_32
>> hardware.
>>
>
> Under the same conditions, i.e. making sure that with the oldest gcc we
> still care about (3.2) we don't end up uninlining any new cases we
> shouldn't.

Looks like this thread is dead/dying, but figured I should reply with
my test findings. The number of out-of-line calls (as determined by:
make mrproper && make defconfig && make && objdump -d vmlinux | grep
"call.*\<memset" | wc -l))

gcc 4.2.4 - withOUT memset patch: 20
gcc 4.2.4 - with memset patch: 365

gcc 3.4 - withOUT memset patch: 17
gcc 3.4 - with memset patch: 349

I'm guessing this is probably not acceptable, so I won't bother
installing/trying gcc-3.2 unless anyone thinks that a 300+ increase in
out-of-line calls is OK.

Joe
