Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXDMKOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXDMKOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 06:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXDMKOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 06:14:42 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:27861 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXDMKOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 06:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eKVO+dCctNMWwy/TK1AFBuGeKLGtnVnGl1f16SY8VrXyAMxALTKIXf5alBx9tDYKHPbcQ18+pQawdPH5yvg/Bg7HAPWQMoCI8F2JYXLjiB3A/01NvE/eJXv2tnUe6x4gtnFp3hDOqJBDp+Ef2aI2cMJwN1bRXIBFwQwVLoc0K3Y=
Message-ID: <4af2d03a0704130314s78d0d831ja52fe8f92efe097a@mail.gmail.com>
Date: Fri, 13 Apr 2007 12:14:40 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
In-Reply-To: <200704122336.57600.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460B6E4B.3060004@gmail.com> <200704111640.47171.rjw@sisk.pl>
	 <461CF87C.4060801@gmail.com> <200704122336.57600.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, 11 April 2007 17:02, Jiri Slaby wrote:
> > Rafael J. Wysocki napsal(a):
> > > On Wednesday, 11 April 2007 12:45, Jiri Slaby wrote:
> > >> Rafael J. Wysocki napsal(a):
> > >>> On Wednesday, 11 April 2007 09:36, Jiri Slaby wrote:
> > >>>> Rafael J. Wysocki napsal(a):
> > >>>>> On Monday, 9 April 2007 22:07, Jiri Slaby wrote:
> > >>>>>> I have bad news for you :(. I thought I had unpatched kernel, but it happens
> > >>>>>> in -rc6 too.
> > >>>>> I guess you mean you're still seeing the 'not enough memory to suspend'
> > >>>>> problem?
> > >>>> Yes:
> > >>>> Disabling non-boot CPUs ...
> > >>>> kvm: disabling virtualization on CPU1
> > >>>> Breaking affinity for irq 9
> > >>>> CPU 1 is now offline
> > >>>> SMP alternatives: switching to UP code
> > >>>> CPU1 is down
> > >>>> swsusp: critical section:
> > >>>> swsusp: Need to copy 158309 pages
> > >>>> swsusp: Not enough free memory
> > >>>> Error -12 suspending
> > >>>> Enabling non-boot CPUs ...
> > >>>> SMP alternatives: switching to SMP code
> > >>>> Booting processor 1/2 APIC 0x1
> > >>>> Initializing CPU#1
> > >>> How reproducible is it?  I'm going to try to reproduce it on one of my boxes.
> > >> My tip is one of three cases: after some work on fresh boot -- some
> > >> consumers such as thunderbird, firefox, 10 or so terminals with
> > >> gnome-session. Single xterm + gnome-session semms not to be a problem.
> > >
> > > Does the workaround with setting the image size below 1/2 of RAM work for you?
> >
> > Yes. Yesterday I must set the value to 350M -- 400M was not enough.
>
> Well, I can't reproduce it.
>
> Can you please try to reproduce it with the appended patch applied and send
> the output of dmesg to me?
>
> Greetings,
> Rafael
>
> ---
>  kernel/power/snapshot.c |    4 ++--
>  kernel/power/swsusp.c   |   16 ++++++++++++----
>  2 files changed, 14 insertions(+), 6 deletions(-)

Shrinking memory...  Pages needed: 128103 normal, 0 highmem
Pages needed: 125226 normal, 0 highmem
Pages needed: -5757 normal, 0 highmem
Pages needed: -5757 normal, 0 highmem
Pages needed: -5757 normal, 0 highmem
Pages needed: -5757
Pages needed: 127953 normal, 0 highmem
Pages needed: 125076 normal, 0 highmem
Pages needed: -6043 normal, 0 highmem
Pages needed: -6043 normal, 0 highmem
Pages needed: -6043 normal, 0 highmem
Pages needed: -6043
done (200 pages freed)
Freed 800 kbytes in 0.16 seconds (5.00 MB/s)
Suspending console(s)
...
CPU1 is down
swsusp: critical section:
swsusp: Need to copy 131358 pages
swsusp: Normal pages needed: 131358
swsusp: Normal pages needed: 131358 + 1024 + 22, available pages: 130607
swsusp: Not enough free memory
Error -12 suspending
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Not responding.
Inquiring remote APIC #1...
... APIC #1 ID: failed
... APIC #1 VERSION: failed
... APIC #1 SPIV: failed
kvm: disabling virtualization on CPU1
Error taking CPU1 up: -5
PCI: Setting latency timer of device 0000:00:01.0 to 64

Please note the CPU#1 bring up problem too. Whole dmesg at:
http://www.fi.muni.cz/~xslaby/sklad/dmesg.nomem

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
