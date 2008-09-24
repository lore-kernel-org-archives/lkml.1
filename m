Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYIXQUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYIXQUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYIXQT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:19:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:53493 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYIXQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:19:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HC1drVJfaSZilC0oGvIAyK9/CGgLLIg/qKOR3oh54REW8nqs6B4hiK4ExlE5QV0aor
         hGsJYBiQXXZ0UKy1d/rU6V7fXNCRBNzHuZuCanTRuBk07NzT8ZLp9dS5cgSWfS0AyaoH
         KzwbnTP6FJfNUvfUCNfEHt5oDZjAlirKgoLx8=
Message-ID: <35f686220809240919x631d8f98m5f1d20c2c8e98690@mail.gmail.com>
Date: Wed, 24 Sep 2008 09:19:44 -0700
From: "Alok kataria" <alokkataria1@gmail.com>
To: "Yan Li" <elliot.li.tech@gmail.com>
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Cc: "Cristi Magherusan" <cristi.magherusan@net.utcluj.ro>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, nancydreaming@gmail.com,
       akataria@vmware.com, "Zachary Amsden" <zach@vmware.com>,
       "Daniel Hecht" <dhecht@vmware.com>
In-Reply-To: <20080924142322.GA21049@yantp.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D12490.5010003@zytor.com>
	 <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
	 <1222265424.5708.5.camel@localhost>
	 <20080924142322.GA21049@yantp.cn.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 7:23 AM, Yan Li <elliot.li.tech@gmail.com> wrote:
> On Wed, Sep 24, 2008 at 05:10:24PM +0300, Cristi Magherusan wrote:
>> On Wed, 2008-09-24 at 20:22 +0800, Yan Li wrote:
>> > Detects whether we are running as a VMware guest or not. Detection is
>> > based upon DMI vendor string.
>> >
>> > It provides a function:
>> > int is_vmware_guest(void)
>> > that can be used easily to detect if we are running as a VMware guest
>> > or not.
>>
>> We can also use this feature to force the HZ value to 100 or 250 at most
>> when running in a virtual environment, since VirtualBox had some issues
>> with this by taking a lot of CPU time when the HZ was set to 1000.
>
> That's good. But this function is used for detecting VMware guest
> only.  Do you think VMware also suffers from this problem?
>

Hi Yan,

Thanks for doing this patch.
It would be really beneficial to detect if we are running on a
hypervisor in general. Though i think the approach should be more
generic,  so that we have a common interface for all the hypervisors.
I have some patches which use "cpuid" to detect if we are running on a
hypevisor and use various cpuid leafs to get some hypervisor specific
info.
This CPUID interface will be available only in the newer (read,
Hardware version 7) version of VMware products. So still for the
products which don't use the newer hardware version, this patch is
helpful.

Btw, are you pushing these patches for the 2.6.27 release ? If this is
for the x86 tree(2.6.28) i think we should hold on, until i post the
proposal for the cpuid patches, so that we can unify this and have a
generic way to detect on which hypervisor are we running .

Thanks,
Alok
> --
> Li, Yan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
