Return-Path: <linux-kernel-owner+w=401wt.eu-S1422908AbXDRMFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422908AbXDRMFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422916AbXDRMFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:05:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:47885 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422908AbXDRMF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=eoKtAqP2NkQrmAx7WtXZyP5Zd5w11RjlcmS9ZVBbq++o8IlnWqexeu7ftks2PZ2ziMXS77SdHHh4RJqWIP5GGkfieBVCheUzOUh0fcTu0jBaZwluMQdkee9jnMP96mGxn6hUQ0laLGr40p1vsSYLjhjQARLXzAj8BIOknltej5s=
Message-ID: <46260981.1040109@gmail.com>
Date: Wed, 18 Apr 2007 21:05:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Chuck Ebbert <cebbert@redhat.com>, emisca <emisca.ml@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it> <88Sov-662-3@gated-at.bofh.it> <88SHV-6uL-29@gated-at.bofh.it> <8agVk-3wc-81@gated-at.bofh.it> <8b3IR-4mE-25@gated-at.bofh.it> <8b3SA-4z3-5@gated-at.bofh.it> <8b42g-51N-15@gated-at.bofh.it> <8bbdm-7iS-27@gated-at.bofh.it> <E1He8dA-0000mw-LI@be1.lrz>
In-Reply-To: <E1He8dA-0000mw-LI@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
>> SCSI part of the fix is queued in scsi-misc-2.6 tree and libata-dev part
>> is acked and waiting to be merged, so the fix will be available in
>> 2.6.22.  However, it's disabled by default to remain compatible with the
>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> current behavior and requires userland change to fully fix the problem.
>   ^^^^^^^^^^^^^^^^
> It sounds like the Schilling kind of compatibility: "The old burner destroyed
> your disk on buffer underruns, therefore the new thing should do the same
> instead of giving you a perfectly readable data disk."
> 
> Guys, not destroying hardware is _NOT_ bad!

Not that simple.  Most disks don't spin up on SYNCHRONIZE_CACHE if its 
cache is clean.  Sadly some disks actually spin up when it receives spin 
down command while spun down to immediately spin down again, so we would 
be fixing problem for some number of disks while breaking others.  :-(

-- 
tejun
