Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYFIBoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYFIBoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 21:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYFIBoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 21:44:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:39288 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbYFIBoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 21:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=m6Yptnn9ZKPPwSpEzIUfVXGtf3cDgJ89VGqHJqQEEBTG67+6pJq6doisuaWKZ4X2g+
         qA3CrazLnub2re4jRi0/KQjUn6nchBLj2eeSqT+8u7XXkCxdYstuJTdEEubkacT92SxO
         gT/JJtqmzeoL/D0AaVwVeUaz923eTYN8d89J8=
Message-ID: <484C8AE1.3010908@gmail.com>
Date: Mon, 09 Jun 2008 10:44:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
References: <20080528143857.GB5585@homac.suse.de> <4845886E.2010505@garzik.org> <20080603181346.GA5013@srcf.ucam.org>
In-Reply-To: <20080603181346.GA5013@srcf.ucam.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Jun 03, 2008 at 02:07:42PM -0400, Jeff Garzik wrote:
> 
>> It would be nice if you and Holger could work together to produce a 
>> single patch[set]...  right now I have patches from both of you, and I 
>> was sorta waiting on the thread to die down to see if competing patches 
>> might merge into a single set
> 
> I think we were waiting for feedback from Tejun as to why removing the 
> port freeze call fixed the hang I was seeing? Beyond that, Holger's 
> latest patch looked good to me.

Sorry, was off for the last week.

The difference between freezing and scheduling EH is that the former 
immediately aborts all in-flight commands and resets the port while the 
latter waits till the in-flight commands finish or time out (EH 
scheduling kicks fast-drain and the timeout is reduced to three seconds).

TF-based ATA controllers are very sensitive to how the registers are 
accessed and sometimes lock up the whole machine when they are not happy 
by indefinitely holding the PCI bus.  This could have been the case if 
IOs were in flight when the dock event occurred.  Were they?

Thanks.

-- 
tejun
