Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYJZKaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYJZKaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYJZK3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:29:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:26912 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYJZK3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from:sender;
        b=JwH2wNH0DzhJrmwfs5llY6GFvOVuwh5uoRjoDQiBilGv5ttW2dm47seKCZYQVztwuY
         VfUcIgFkXR0YJm9f95xOUNPs2dRyfNodI9hDOrH4SOSNg1wi5H946/bkht7wT17DXoh7
         yDP0EAutu1thZG1uDkLQJzxaMgTs8t1vo5qEY=
Message-ID: <4904469A.2090803@tuffmail.co.uk>
Date: Sun, 26 Oct 2008 10:29:46 +0000
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Francois Valenduc <francois.valenduc@tvcablenet.be>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: [Bug #11841] plenty of line "ACPI: EC: non-query interrupt received,
 switching to interrupt mode" in dmesg
References: <bqZlc-1BT-11@gated-at.bofh.it> <bqZuJ-22l-15@gated-at.bofh.it> <r6ljwccagm.fsf@skye.inf.phy.cam.ac.uk>
In-Reply-To: <r6ljwccagm.fsf@skye.inf.phy.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanjoy Mahajan wrote:
>> The following bug entry is on the current list of known regressions
>> from 2.6.27.
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11841
>> Subject : plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg
> 
> I see these messages already with 2.6.27.3:
> 
>   # grep non-query /var/log/dmesg
>   [    0.205977] ACPI: EC: non-query interrupt received, switching to interrupt mode
> 
> There are 9 more occurrences in the current ring buffer:
>   # dmesg |grep non-query | wc -l
>   9
> 
> Each one happens right after waking from S3 sleep, for example:
> 
>   [70168.288590] CPU1 is up
>   [70168.288594] ACPI: Waking up from system sleep state S3
>   [70169.624254] ACPI: EC: non-query interrupt received, switching to interrupt mode
> 
> The setup is a TP T60 w/ Intel graphics, wireless (i.e. no taint),
> Debian unstable, but with vanilla kernel 2.6.27.3.
> 
> -Sanjoy

It's expected that you see that message on both boot and every wakeup from suspend.

If you look at the dmesg Francios' posted, his issue is that there are _floods_ of this message during boot.  That's not expected :).

Regards
Alan
