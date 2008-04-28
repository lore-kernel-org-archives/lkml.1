Return-Path: <linux-kernel-owner+w=401wt.eu-S935937AbYD1Vjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935937AbYD1Vjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbYD1Vjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:39:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:19099 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765971AbYD1Vjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TI3nvX1DbnPqqRz89+8G9PW0RMEG8ghyqFHWH1Qjbw8QnmNrNVndSLj5g8nDqZj/9yzUTOT9HmOL1rfjtzD4x7vdLxclaP4/vq8h/aJ6fhmbReVeJfEKLi1HI3cpd7aJPN1KG1JcZXc75HoVAnj9d7aO7JEZjL7t6z+ZIRUUhV8=
Message-ID: <2c0942db0804281439j492ab98fmf80e5ab669b6c9e1@mail.gmail.com>
Date: Mon, 28 Apr 2008 14:39:30 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Cc: "Daniel Klaffenbach" <danielklaffenbach@gmail.com>,
       "Len Brown" <lenb@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEF31967@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804242015.19462.lenb@kernel.org>
	 <200804281209.47927.danielklaffenbach@gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEEF31621@orsmsx423.amr.corp.intel.com>
	 <200804282001.06680.danielklaffenbach@gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEEF31967@orsmsx423.amr.corp.intel.com>
X-Google-Sender-Auth: b89457a176a491d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 2:13 PM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
>  >-----Original Message-----
>  >From: Daniel Klaffenbach [mailto:danielklaffenbach@gmail.com]
>
> >Sent: Monday, April 28, 2008 11:01 AM
>  >To: Pallipadi, Venkatesh
>  >Cc: Len Brown; Linux Kernel Mailing List
>  >Subject: Re: [2.6.25-stable PATCH] regression: powertop says
>  >120K wakeups/sec
>  >
>
>
> >Pallipadi, Venkatesh wrote:
>  >> Did C1, C2 work fine with 2.6.24?
>  >> Can you send me the full dmesg when it is failing to enter
>  >C1, C2 with
>  >> latest git + patch.
>  >> Output of
>  >> #grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*
>  >> And also attach the acpidump output (pmtools package here
>  >> http://www.lesswatts.org/projects/acpi/utilities.php)
>  >No, C1/C2 did not seem to work with 2.6.24 - at least powertop
>  >reported 99,9%
>  >C0 usage. It was the same behavior as after applying the wakeup patch.
>  >However in 2.6.25 and 2.6.25-git11 C1/C2 worked correctly and
>  >C2 showed up in
>  >pt. But after applying your patch to 2.6.25-git11 they did not:
>  >
>  >git11:
>  >PowerTOP version 1.9       (C) 2007 Intel Corporation
>  >Cn                Avg residency       P-states (frequencies)
>  >C0 (cpu running)        ( 9,4%)         1,80 Ghz   100,0%
>  >C1                0,0ms ( 0,0%)         1,60 Ghz     0,0%
>  >C2                0,4ms (90,6%)          800 Mhz     0,0%
>  >Wakeups-from-idle per second : 9051,0   interval: 5,0s
>  >
>  >git11 with wakeup-patch:
>  >PowerTOP version 1.9       (C) 2007 Intel Corporation
>  >Cn                Avg residency       P-states (frequencies)
>  >C0 (cpu running)        (99,9%)         1,80 Ghz   100,0%
>  >C1                0,0ms ( 0,0%)         1,60 Ghz     0,0%
>  >C2                0,2ms ( 0,1%)          800 Mhz     0,0%
>  >Wakeups-from-idle per second : 59,8     interval: 10,0s
>  >
>  >In both cases the system was idle. I've uploaded the files you wanted:
>  >http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11.txt
>  >http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11
>  >_wakeuppatch.txt
>  >http://www-user.tu-chemnitz.de/~klada/misc/kernel/dmesg_git11.txt
>  >http://www-user.tu-chemnitz.de/~klada/misc/kernel/dmesg_git11_w
>  akeuppatch.txt
>  >http://www-user.tu-chemnitz.de/~klada/misc/kernel/nx6125_acpidump.out
>  >
>  >If there is anything else I can do for debugging this issue
>  >please let me
>  >know.
>  >
>
>  With git11+wakeup patch, things seems to be working fine as per
>  >http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11_wakeupp
>  atch.txt
>
>  CPU is spending most of the time in C3 state. Looks like there is some
>  problem with
>  powertop reporting here. I know there were some changes to this area in
>  powertop.
>  Can you try the latest powertop version from svn
>  (http://www.lesswatts.org/projects/powertop/download.php) and see
>  whether the issue is fixed.

I have the same laptop. Powertop (as I'd last tested it) misreports C3
as C2 -- the laptop (nx6125) does not support C2 according to

$ cat /proc/acpi/processor/C000/power
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 2000 usec
states:
     C1:                  type[C1] promotion[--] demotion[--]
latency[000] usage[21566331] duration[00000000000000000000]
     C2:                  <not supported>
     C3:                  type[C3] promotion[--] demotion[--]
latency[010] usage[20968443] duration[00000000000478095079]

I sent a patch for powertop (
http://www.bughost.org/pipermail/power/2008-February/001306.html ),
but as far as I can see it hasn't been picked up. (Perhaps it's wrong
or incomplete, dunno -- Arjan never replied.) [goes and pulls svn...]
Powertop SVN head (rev 290) still has the problem.
