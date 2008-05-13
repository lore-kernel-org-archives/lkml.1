Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbYEMVJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbYEMVJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbYEMVJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:09:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:56863 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYEMVJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Grz4Jl7deEh76omJvZiijFpBHxG1dy6IzDT7LiABKK4D5dy6Zg0dNNlQ13tNepBFbrTjnRauoqs9RcSV4Vc5Ir86SpZN+rIeIeD4dUxahYIYu/fD8KVJLNssnE8nc3BcNJMz+ox/PIzhAwyxIDfbrEPcwP44DBW+v+Pm11kxU7g=
Message-ID: <19f34abd0805131409w2914fbedgb608c7b87c234e2e@mail.gmail.com>
Date: Tue, 13 May 2008 23:09:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "=?UTF-8?Q?S.=C3=87a=C4=9Flar_Onur?=" <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, "Matt Mackall" <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <873aol9b73.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513204206.GA17781@damson.getinternet.no>
	 <873aol9b73.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:54 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Vegard Nossum <vegard.nossum@gmail.com> writes:
>  >
>  > This initially showed up on my 2.6.24.5-85.fc8 (Fedora) kernel.
>  >
>  > I have two different systems (one laptop, one desktop) which both show the
>  > same symptoms, please do tell me if you need any more info.
>
>  What CPUs do they have?  And does the problem really go away when
>  you boot with idle=mwait ? And what does the following program
>  output?

Yes, the problem goes away with idle=mwait.

The desktop is a P4:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 5
cpu MHz         : 2992.624
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc pebs bts pni monitor ds_cpl est tm2 cid cx16 xtpr
lahf_lm
bogomips        : 5990.81
clflush size    : 64

(similar for processor 1)

# msr
0

The laptop is a Pentium Dual-Core:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz
stepping        : 13
cpu MHz         : 800.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl est tm2 ssse3
cx16 xtpr lahf_lm
bogomips        : 2930.23
clflush size    : 64

(similar for processor 1)

# ./msr
1110


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
