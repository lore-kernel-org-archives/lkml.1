Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0BHTPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:15:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:38244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0BHTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:15:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V/4Ee0spHeiku1tQPjQCzhkXrqJhZ8Sg9eCLIn1D+eHTuCEZIxiZb2D2+eHSkUE00K
         +7mj58L3d6Q7gKxCoJRD44Ej1hfVtsHxVgJYzA7+hWTtBvf1ooslEFcP5qeywveYctUZ
         T2zaQb+QOg1aOLOxdWQPK6xyGxIiGZoCPSmaU=
Message-ID: <4B7062DF.2020005@gmail.com>
Date: Mon, 08 Feb 2010 20:15:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, x86@kernel.org,
       Aristeu Sergio <arozansk@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/1] X86: pci, fix section mismatch
References: <1264756956-30006-1-git-send-email-jslaby@suse.cz> <20100208104426.50bef125@jbarnes-piketon>
In-Reply-To: <20100208104426.50bef125@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2010 07:44 PM, Jesse Barnes wrote:
> On Fri, 29 Jan 2010 10:22:36 +0100
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> pcibios_scan_specific_bus calls pci_scan_bus_on_node which is
>> __devinit. Mark pcibios_scan_specific_bus __devinit as well since
>> all users are now __init or __devinit.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Cc: linux-pci@vger.kernel.org
>> Cc: x86@kernel.org
>> ---
>>  arch/x86/pci/legacy.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
>> index a8194c8..8cf7835 100644
>> --- a/arch/x86/pci/legacy.c
>> +++ b/arch/x86/pci/legacy.c
>> @@ -39,7 +39,7 @@ static int __init pci_legacy_init(void)
>>  	return 0;
>>  }
>>  
>> -void pcibios_scan_specific_bus(int busn)
>> +void __devinit pcibios_scan_specific_bus(int busn)
>>  {
>>  	int devfn;
>>  	long node;
> 
> Does this apply to some x86 tree that I can't see?  Neither my tree nor
> the -tip tree has this function and I don't see it in the history.

Ah, this seems to come from
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git#linux_next

as SHA:
a120a84ebbc4cbc9c1addddd2b491e3683b842a6

I'll resend to Mauro.
