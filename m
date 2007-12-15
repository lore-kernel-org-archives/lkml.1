Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbXLOCOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbXLOCOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 21:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXLOCOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 21:14:00 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:61709 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbXLOCN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 21:13:59 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/TCttuYHwfm8krYzDiOxv1
Message-ID: <4763385E.9040106@reed.com>
Date: Fri, 14 Dec 2007 21:13:50 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <4762AA68.9030507@qumranet.com>
In-Reply-To: <4762AA68.9030507@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> kvm will forward a virtual machine's writes to port 0x80 to the real 
> port.  The reason is that the write is much faster than exiting and 
> emulating it; the difference is measurable when compiling kernels.
>
> Now if the cause is simply writing to port 0x80, then we must stop 
> doing that.  But if the reason is the back-to-back writes, when we can 
> keep it, since the other writes will be trapped by kvm and emulated.  
> Do you which is the case?
>
As for kvm, I don't have enough info to know anything about that.  Is 
there a test you'd like me to try?

I think you are also asking if the crash on these laptops is caused only 
by back-to-back writes.  Actually, it doesn't seem to matter if they are 
back to back.  I can cause the crash if the writes to 80 are very much 
spread out in time - it seems only to matter how many of them get 
executed - almost as if there is a buffer overflow.  (And of course if 
you do back to back writes to other ports that are apparently fully 
unused, such as 0xED on my machine, no crash occurs).

I believe (though no one seems to have confirming documentation from the 
chipset or motherboard vendor) that port 80 is actually functional for 
some unknown function on these machines.   (They do respond to "in" 
instructions faster than a bus cycle abort does - more evidence).

I searched the DSDT to see if there is any evidence of an ACPI use for 
this port, but found nothing.




