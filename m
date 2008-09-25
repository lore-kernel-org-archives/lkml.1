Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYIYAcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYIYAcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYIYAc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:32:28 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:28810 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbYIYAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p66aSBG2Uo7oTG+ni/Rs4Xbk3/QUxbFSL36ba8/1WfNDGOabBgm8chZ3jDFJ/gk1GP
         6KO1Zg/PozEB6I/pe9NeM9HLzFovtp841jcd6cD3tQEjYp+glYVbPC6CH4iMYvew/dqB
         mNq6UVhy11nvC6JGAYYZOZ2gIsWheeIa/ie94=
Date: Thu, 25 Sep 2008 08:32:20 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925003220.GE21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <48DA6887.1060709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DA6887.1060709@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:19:19AM -0700, H. Peter Anvin wrote:
> Yan Li wrote:
>> I haven't used PCI vendor Id since that requires copying a trunk of
>> codes from early_quirks() and I think copying code is not good. And
>> reusing codes from early_quirks() needs intrivial change to present
>> codes structure. Comparatively, checking "VMware" string against DMI
>> manufacturer is a lot more simpler (one-line code). Also there's no
>> evidence indicating that VMware will change their vendor string in
>> near future. Therefore I choose to use simpler way.
>>
>> Tested on x86 and x86-64 VMs and machines.
>
> I'd like to make this a general VM platform detection subsystem.  We  
> have similar issues with Virtual PC, and again, DMI appears to be the  
> sanest way to detect it -- at least to a primary screen.

I think if Virtual PC has similar problems we should add codes to
detect Virtual PC to be used by mtrr/main.c. A general interface might
not be good for this specific problem (false MTRR blank warning) since
we have no way to know all VMs has MTRR set to blank thus handling
KVM, VMware and Virtual PC here should be enough for now.

If you can tell me what manufacture vendor string is in Virtual PC I
can make another similar patch using dmi_name_in_vendors().

So at first I'd like to see the false warning for VMware and Virtual
PC get fixed soon.

-- 
Li, Yan
