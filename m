Return-Path: <linux-kernel-owner+w=401wt.eu-S1765461AbXGaQSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765461AbXGaQSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXGaQSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:18:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:46050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbXGaQSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:18:37 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Subject: Re: acpi=off vs. blacklist (HP DC 7700)
Date: Tue, 31 Jul 2007 12:18:23 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200707311235.53302.philipp.marek@bmlv.gv.at>
In-Reply-To: <200707311235.53302.philipp.marek@bmlv.gv.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311218.23154.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2007 06:35, Ph. Marek wrote:
> Hello everybody!
> 
> I have two machines which freeze during boot; this seems to be ACPI-related, 
> because with acpi=off they start.
> 
> The first one is the HP DC 7700; some summary can be seen on
>   http://forums1.itrc.hp.com/service/forums/questionanswer.do?threadId=1081719
> It hangs after a line
>   ACPI assume root bridge[\sp_.pci0] bus is 0

Looks like this box has been broken since December, 2006!
Not booting unless "acpi=off" is a serious failure.

> The second one is a notebook; a Roda Rocky III+ RK886EX, which just shows a 
> blank screen.

Please get Linux up and running on the two boxes
using whatever means are at your disposal (some mentioned
in the thread above are acpi=off, pci=noacpi,
pci=conf1, noapic hda=noprobe hdc=noprobe)

Download the latest stable kernel.org kernel (2.6.22.1 today)
Make sure that the latest kernel still fails unless
you apply the workaround(s).

Then open two a bug report for each machine here:
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

Attach the output from acpidump, as well as the
complete dmesg and lspci -vv output,
and paste the contents of /proc/interrupts.
Then, if you can capture the console output taken from the actual failure
case, that would be ideal

> As we drive many machines from the same kernel image via PXE, I tried to 
> insert them into drivers/acpi/blacklist.c; but that doesn't help, either - 
> the notebook hangs as before, no matter whether I set is_critical_error or 
> not. 
>  [ I suppose I wrote the entries wrong; is there some HOWTO? I used
>    acpidump/acpixtract/acpitbl, copied other blacklist entries, and took
>    "OEM Table ID", "OEMID", "OEM REVISION". Help? ]

Lets see if we can find out what the problem is before we
blacklist the machines.

thanks,
-Len
