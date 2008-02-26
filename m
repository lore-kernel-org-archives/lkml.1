Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYBZDhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYBZDhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760487AbYBZDhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:37:08 -0500
Received: from web53812.mail.re2.yahoo.com ([206.190.39.55]:25896 "HELO
	web53812.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760188AbYBZDhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:37:05 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 22:37:05 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=SH3+6rLi7vt+TgccF8mMIpzWgTudGyraJ1HdWzcMJpKYi0GR7tjXU02R52t88qr1jlRXyPE5vV6+5VU0B5qCjsq8evGPQcsU2Ugr94G+M1LoFLAcXGd70LRhXpaiDtMe3E1V3z/44B52F9HgmCGqHpW8sZBbXiQkkDYpbR9LZj0=;
X-YMail-OSG: UzgRD9wVM1lee9mZJau7LR.SRl8E0Q28iWCLsHLjFkYra8P041jlrdru6d.rryZYkNB1exkUCg--
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.162
Date: Mon, 25 Feb 2008 19:30:24 -0800 (PST)
From: <caiying@yahoo.com>
Subject: Re: Configure MSI-X vectors to target different CPUs
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <571243.11353.qm@web53812.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Robert. My device does support multiple vectors.

When looking into functions called by pci_enable_msix(), I found msi_compose_msg() in arch/i386/kernel/io_apic.c. It tries to get destination CPU (TARGET_CPUS) and set this information to msg->address_lo. My question is about TARGET_CPUS. Under the asm-i386/mach-default, it is the cpu_online_map. Under asm-i386/mach-bigsmp, it is the cpumask_of_cpu(cpu), where cpu is a single one. I would guess if a single CPU is set as destination, only that CPU will be interrupted. But what will happen when the cpu_online_map is set as destination? Any CPU can be interrupted then? Or depending on affinity of the corresponding irq?

Please 
CC'ed 
me 
(caiying@yahoo.com) 
answers/comments  
in 
response 
to 
this 
posting. 

Thanks,
Ying

----- Original Message ----
From: Robert Hancock <hancockr@shaw.ca>
To: caiying@yahoo.com
Cc: linux-kernel@vger.kernel.org
Sent: Thursday, February 21, 2008 7:59:14 PM
Subject: Re: Configure MSI-X vectors to target different CPUs


caiying@yahoo.com 
wrote:
> 
Hi,
> 
> 
In 
MSI-HOWTO, 
it's 
said:
> 
> 
"Using 
MSI 
enables 
the 
device 
functions 
to 
support 
two 
or 
more 
vectors, 
which 
can 
be 
configured 
to 
target 
different 
CPUs 
to 
increase 
scalability."
> 
> 
So 
how 
can 
I 
set 
up 
MSI-X 
vectors 
to 
target 
different 
CPUs? 
I 
want 
to 
allocate 
the 
same 
number 
of 
MSI-X 
vectors 
as 
CPUs, 
and 
equally 
distribute 
them 
to 
every 
CPU.
> 
> 
Is 
it 
automatically 
done 
by 
Linux 
when 
I 
call 
pci_enable_msix()? 
If 
yes, 
how? 
If 
not, 
what 
should 
I 
do? 
My 
guess 
is 
to 
set 
the 
affinity 
of 
the 
interrupts 
manually. 
Am 
I 
right?
> 
> 
Please 
CC'ed 
me 
(caiying@yahoo.com) 
answers/comments  
in 
response 
to 
this 
posting. 
> 
> 
Thanks,
> 
Ying

If 
the 
device 
actually 
supports 
multiple 
vectors 
(not 
all 
do), 
I 
think 
they 
should 
show 
up 
as 
separate 
interrupts 
in 
/proc/interrupts 
and 
you 
can 
either 
set 
the 
affinity 
manually, 
or 
maybe 
irqbalance 
is 
smart 
enough 
for 
this.

Careful, 
though, 
as 
in 
some 
cases 
this 
may 
reduce 
performance 
due 
to 
causing 
more 
cache 
line 
bouncing 
between 
CPUs.



