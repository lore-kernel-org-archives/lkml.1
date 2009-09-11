Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZIKHsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZIKHsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZIKHsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:48:46 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:63252 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZIKHso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XaNnjyIP0/++FPusHZLBFK3S/xL+MYroVqP51PJRZD1Zp4p0Q/azyDpfh71+zhnJpJ
         UZ5IjoKfHwV1MI7q9BeXka4NsH//rAR8BmGgVMGekXHCqPxtOr9f/VJKXkw5OjeAOAsO
         69fUfGULC3UQj6tvZKYCg9Wf9S3D4HLXo35bA=
MIME-Version: 1.0
In-Reply-To: <c4e36d110908260712u3aa0e27ft869049aa310a7386@mail.gmail.com>
References: <c4e36d110908250110xe16720o977c8cf5c3386c4b@mail.gmail.com>
	 <200908251251.37135.bjorn.helgaas@hp.com>
	 <c4e36d110908251333p2da20276j650232cea8da4c1f@mail.gmail.com>
	 <200908251459.37106.bjorn.helgaas@hp.com>
	 <c4e36d110908260712u3aa0e27ft869049aa310a7386@mail.gmail.com>
Date: Fri, 11 Sep 2009 09:48:46 +0200
Message-ID: <c4e36d110909110048i45e55d43vf4a4d94320be703f@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency - kacpid 
	acpi_os_wait_events_complete
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, Paul Martin <pm@debian.org>,
       Vojtech Gondzala <vojtech.gondzala@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/26 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/8/25 Bjorn Helgaas <bjorn.helgaas@hp.com>:
>> On Tuesday 25 August 2009 02:33:30 pm you wrote:
>>> 2009/8/25 Bjorn Helgaas <bjorn.helgaas@hp.com>:
>>> > On Tuesday 25 August 2009 02:10:58 am Zdenek Kabelac wrote:
>>> >> Now with 2.6.31-rc7 (3edf2fb9d80a46d6c32ba12547a42419845b4b76)
>>> >>  I'm getting this  INFO trace - also I've noticed complete reset during resume
>>> >> which could be eventually related to this
>>> > Do you have any evidence that points to thinkpad_acpi?  I looked
>>> > at the recent changes there, and I don't see anything obviously
>>> > related to kacpid or deferred work.
>>> >
>>>
>>> Well I've never seen this INFO trace before - also I'm not sure I
>>> could reliable retest it - might be coincidence of suspend out of port
>>> replicator and resume while being attached on it - however I do this
>>> relatively often and I start to see this after I' started to use -rc7
>>> kernel.
>>>
>>> My guess is purely based on the fact that commit touching functions
>>> from INFO trace was recently merged to main tree.
>>>
>>> If there will be some time I could try to make few tests for suspend
>>> resume - but I hope the trace would be enough for analysis.
>>
>
> Well definitelly I do not have a reliable test case to
> deterministically trigger this INFO trace, but I think from the trace
> it looks like  the acpi_os_wait_events_complete calls flush_workqueue
> which again calls acpi_os_execute_hp_deferred which again tries to
> invoke flush_workqueue - so is that correct ?
>
> (__acpi_os_execute looks somewhat cryptic in selection what would be called)
>
> This is the stack traceback cut from my first post:
>
>  [<ffffffff81064df0>] ? flush_workqueue+0x0/0xc0
>  [<ffffffff81261532>] ? acpi_os_execute_hp_deferred+0x0/0x43
>  [<ffffffff81064e4f>] flush_workqueue+0x5f/0xc0
>  [<ffffffff81064df0>] ? flush_workqueue+0x0/0xc0
>  [<ffffffff81261524>] acpi_os_wait_events_complete+0x15/0x23
>  [<ffffffff81261561>] acpi_os_execute_hp_deferred+0x2f/0x43
>  [<ffffffff810651d4>] worker_thread+0x1e4/0x3f0
>
> So it looks like this issue is releated to commit:
> c02256be79a1a3557332ac51e653d574a2a7d2b5
>
> Hopefully the author would be able to fix this ?
>

Hi

Any progress with this issue - I'm still getting this INFO trace even
with 2.6.31

Zdenek
