Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZETGKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZETGKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 02:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZETGKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 02:10:30 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:64338 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZETGK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 02:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jgu9d/ew/7fAt/hgI0oKoQEvBwpc5LOd/9Bq695pRUT7h2hr6xI8pBH7wW0Ud3iW4x
         2YFt1Nfxv7q7WTgpuQga1BCjQIZpYY1tRupuKYp40rMEYM3gaooBfE14mp0cIEst3T63
         3VvZKIJWL3tpN3Sd2KAJP1o0k4URGv3xKfwzQ=
Message-ID: <4A139ED3.5060201@gmail.com>
Date: Wed, 20 May 2009 00:10:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jonathan Steinert <hachi@kuiki.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: problem with sata_sil24: PCI fault or device removal?
References: <20090519213008.GA21409@miyako.harrison.succub.us>
In-Reply-To: <20090519213008.GA21409@miyako.harrison.succub.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Steinert wrote:
> I have a box here running 2.6.26 x86_64 normally (also tested with 2.6.29, and going to test with later versions too) that has major issues with SATA. I'm not sure which things are causes and which things are side effects, so I'm just going to list symptoms.
> 
> I'm happy to use this machine for debugging, but I'm not subscribed to lkml. If you could please CC me on responses that would help a lot.
> 
> - The first error I usually see is:
> 
> sata_sil24: PCI fault or device removal?
> 
> - In some cases I've had the box hard-lock (no magic SysRq response or anything) with no errors.
> 
> - Booting a live OS with 2.6.25 @ 32bit seems to be just fine, but this could be a side effect of 32 vs 64bit. Not sure yet.
> 
> - SMART commands might make the situation worse. I was using smartmontools to run long self-tests on the drives every sunday, and tends to crash on sunday around the time of the long test starting. I was also using hddtemp and it got a little less frequent when I removed that.
> 
> - Lots of IO does make it worse. dd if=/dev/sdwhatever of=/dev/null can get it to start spewing errors within a minute usually.
> 
> - Logs and command outputs are at: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/
> 
>     lspci: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/lspci.txt
>     lspci -vvv: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/lspci_long.txt
>     dmesg: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/dmesg.txt
>     console output during a crash: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/crash1.txt
> 
> If anyone has time to help, it would be much appreicated. I'm able and willing to collect any other information you might want.

What is this controller, an add-in card? The fact that you got a status 
register read returning all ones (think that's the usual result of a PCI 
abort), and these errors:

[ 2094.921961] ata12: irq_stat 0x00020002, PCI master abort while 
transferring data
[ 2099.317472] ata12.00: irq_stat 0x00020002, PCI parity error while 
fetching SGT

really suggest you're having some kind of problems on the PCI bus.. 
Could be a hardware fault, power issue, etc.
