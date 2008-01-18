Return-Path: <linux-kernel-owner+w=401wt.eu-S1764066AbYARX3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764066AbYARX3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 18:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759348AbYARX2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 18:28:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:48592 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939AbYARX2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 18:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OqS9T6ASoWMngW3RbBdTJb1vkXcdmW4Dv/AN5VuSz/0DKtQlID+qzGN61dvGq+jj8MwebigwJyvOr8dKED0EYgK2w1JXNvkwKrfiVHIvDDGyQlnfXierce8xw11hixzsooFRBXDfGWsoEN83lRmsl6qfruRZx7EgvCi3UFYTbAY=
Message-ID: <4791362A.7040200@gmail.com>
Date: Sat, 19 Jan 2008 08:28:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fischer@norbit.de,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH] SCSI: fix isa/pcmcia compile problem
References: <20080117023514.9df393cf.akpm@linux-foundation.org>	 <478F7F2B.9000801@linux.vnet.ibm.com>	 <20080117111104.3baa878e.akpm@linux-foundation.org>	 <47904927.1040000@linux.vnet.ibm.com>  <47905348.1000709@gmail.com> <1200668315.3111.3.camel@localhost.localdomain> <479135EE.2090009@gmail.com>
In-Reply-To: <479135EE.2090009@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> James Bottomley wrote:
>> On Fri, 2008-01-18 at 16:20 +0900, Tejun Heo wrote:
>>> aha152x.c and fdomain are built twice - once for the isa driver and
>>> once for the PCMCIA one.  Through #ifdefs, the compiled codes are
>>> slightly different; thus, global symbols need to be given different
>>> names depending on which flavor is being built.  This patch adds
>>> GLOBAL() macro to aha152x.h and fdomain.h which change the symbol
>>> depending on PCMCIA.
>>>
>>> This bug has always existed but has been masked by the fact the
>>> drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
>>> drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus
>>> avoided the duplicate symbols during compilation.
>>>
>>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>>> ---
>>> Ah... missed that one.  Here's the updated version.
>> Actually, isn't the better fix just to return to the original behaviour?
>>
>> As you pointed out, using the subdir instead of obj meant that although
>> the modules were built, the drivers were never linked into the main
>> kernel.  According to the records, this has been the default forever, so
>> there can be no-one anywhere relying on these drivers being built in.
>> Actually, as old style pcmcia drivers, I'm not sure there's much value
>> building them into the kernel anyway.
>>
>> So just modify scsi/pcmcia/Kconfig to make them all depend on m.
> 
> Yeap, there is no problem if you don't allow them to be linked into the
> kernel.  If that's how you want it, please go ahead.
> 
> I personally think it's a bit odd to disallow building into kernel
> because of the peculiarity of the implementation (including c files and
> compiling them slightly differently) and also no one reporting doesn't
> necessarily mean no one has attempted it and failed.

Actually what's better would be to make all symbols static and include
the c file directly into the stub file.  How about that?

-- 
tejun
