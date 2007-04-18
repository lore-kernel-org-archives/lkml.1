Return-Path: <linux-kernel-owner+w=401wt.eu-S1422993AbXDRNGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422993AbXDRNGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422991AbXDRNGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:06:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:10821 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422993AbXDRNGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ta4B87wfec7KKR+0KW4mxhl4RjqCFVlbpj9EDI2yag2e4PvcWDORviUaYXcFnbuGbb7z+9XcBamNHKvcxAuFdTXRTb+KumwIxR9z2tj0B1AonsEqXcUpYMc2Lw8AmRKWNQWavDTfa5yi5QQKBNPE+byeGvySCyoizDwkGAtoRsY=
Message-ID: <462617B5.8050205@gmail.com>
Date: Wed, 18 Apr 2007 22:05:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: 7eggert@gmx.de, Chuck Ebbert <cebbert@redhat.com>,
       emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it>	<88Sov-662-3@gated-at.bofh.it>	<88SHV-6uL-29@gated-at.bofh.it>	<8agVk-3wc-81@gated-at.bofh.it>	<8b3IR-4mE-25@gated-at.bofh.it>	<8b3SA-4z3-5@gated-at.bofh.it>	<8b42g-51N-15@gated-at.bofh.it>	<8bbdm-7iS-27@gated-at.bofh.it>	<E1He8dA-0000mw-LI@be1.lrz>	<46260981.1040109@gmail.com>	<20070418132904.3322ba5f@the-village.bc.nu>	<46261337.3010406@gmail.com> <20070418140346.636879a1@the-village.bc.nu>
In-Reply-To: <20070418140346.636879a1@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Thought about that and querying power state before doing shutdown 
>> sequence but things get somewhat ugly because shutdown sequence is 
>> driven from sd->shutdown().  We'll have to snoop both sync and shutdown 
>> commands and check whether the system is shutting down.  Also, I felt 
>> very uneasy about faking successful completion to SYNCHRONIZE_CACHE.
> 
> If you see a synchronize cache succeed and you then see the drive
> shutdown succeed then you know that a sync cache can be faked as ok
> safely. Any other command in between or after and it doesn't get faked
> 
> This seems pretty easy to deal with at command issue.

Yeah, right.  I guess I'm too anal about SYNCHRONIZE_CACHE.

>> I dunno.  It's already too late for 2.6.21.  I was hoping we could get 
>> distros to update shutdown utilities in not-too-distant future but I 
>> have no experience with that.  Is that just a wishful thinking?
> 
> Probably not, but it will take a year or so and throughout this time
> period everyone with the wrong combination of shutdown and kernel (which
> will be a lot of people who compile their own kernels) are going to have
> problems caused by what is a very obscure piece of libata internal
> behaviour they'll never even know about.

Okay, will do another round of the patch.

Thanks.

-- 
tejun
