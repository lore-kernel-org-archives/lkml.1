Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbZKFWSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbZKFWSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZKFWSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:18:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47690 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZKFWSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ovie+TyeG4bSSSHxUNRjXpVKTsli4Uqg9XLb7w57Y9aahYPcqj1M6j4HBebHg1YpA3
         us3P3neA1hyEod+4fPH9FvXQTIvQEHc4ST2bc0+CHLde57CmBU1+snrbg+VoMXgnaQNy
         ebmdEVEFufK0xSONW+XJVVlTlgEZlxG9/EVlw=
MIME-Version: 1.0
In-Reply-To: <4AF4526B.4060101@zytor.com>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> 
	<4AF4526B.4060101@zytor.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Fri, 6 Nov 2009 23:18:06 +0100
Message-ID: <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 5:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/06/2009 06:59 AM, Matteo Croce wrote:
>> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
>
> MMX and MMXEXT are hardly hallmarks of i686, which leaves only cmov.
> I'm somewhat wondering about the general value of this patch; is i686
> code really that much faster on Geode that it's worth it?
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>

yes, I did some test like gzip, bzip2, lame etc and they give more or less
the same results of dhrystone

root@alix:/usr/src# CFLAGS='-march=i586' ./dry.c
gcc -c -O3 -march=i586 ./dry.c -o dry1.o
gcc -DPASS2 -O3 -march=i586 ./dry.c dry1.o  -o dry2

Dhrystone Benchmark, Version C, Version 2.2
Program compiled without 'register' attribute
Using times(), HZ=100

Trying 5000000 runs through Dhrystone:
Microseconds for one run through Dhrystone:        1.4
Dhrystones per Second:                          740741

root@alix:/usr/src# CFLAGS='-march=i686' ./dry.c
gcc -c -O3 -march=i686 ./dry.c -o dry1.o
gcc -DPASS2 -O3 -march=i686 ./dry.c dry1.o  -o dry2

Dhrystone Benchmark, Version C, Version 2.2
Program compiled without 'register' attribute
Using times(), HZ=100

Trying 5000000 runs through Dhrystone:
Microseconds for one run through Dhrystone:        1.2
Dhrystones per Second:                          841751
