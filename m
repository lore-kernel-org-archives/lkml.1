Return-Path: <linux-kernel-owner+w=401wt.eu-S965371AbXHJUVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371AbXHJUVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935845AbXHJUVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:21:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:6089 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937526AbXHJUVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=o2nYU8EUCSE0P8Wa1lrB+VNR47+cnA0p16YcTWLecE7PX+4Z2IZF4catVaGSTnm0MwVx9EUywA+rUf0XQR1/hDSsuMW3kfd/FMUoigjbegR1srAJuM5KvF/oDmt6uZHkSmT/eeXZHCZF6Qmy9f+yAgEjD2NQ2UVsytlvjP9+alY=
Message-ID: <46BCC8FC.8020804@gmail.com>
Date: Fri, 10 Aug 2007 22:22:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2 -- conntrack divide error
References: <20070809224254.11f42716.akpm@linux-foundation.org>	 <a8e1da0708100118r779068i64ffdc11e452be9b@mail.gmail.com>	 <20070810013210.1b2f121c.akpm@linux-foundation.org>	 <a8e1da0708100137t48c5c673vf0c98fb5f0cd058b@mail.gmail.com> <a8e1da0708100252g5597da63j9cb665ade26f7654@mail.gmail.com> <46BC49C3.6020100@googlemail.com>
In-Reply-To: <46BC49C3.6020100@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C napsal(a):
> Dave Young wrote:
>>> On 8/10/07, Dave Young <hidave.darkstar@gmail.com> wrote:
>>>> On 8/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>> On Fri, 10 Aug 2007 16:18:38 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
>>>>
>>>>> Hi,
>>>>> 2.6.23-rc2-mm2:
>>>>> config with CONFIG_NF_CONNTRACK_AMANDA=y
>>>>> boot  oops:
>>>>>
>>>>> hand copyed :
>>>>> the EIP: helper_hash
>>>>>
>>>>> backtrace:
>>>>> do_basic_setup
>>>>> ...
>>>>> nf_conntrack_amanda_init
>>>>> error_code
>>>>> do_vivide_error
>>>>> ...
>>>>>
>>>> cc netdev
>>>>
>>>> please send config
>>>>
>>>> presumably nf_ct_helper_hsize is zero

I think so. 2.6.23-rc2-mm1 seemed be OK.

>>>>
>>>> I'd have thought that the same bug would be present in mainline - there's
>>>> nothing in git-net.patch.
>>>>
>>>> (hunts around, discovers that there's a net-2.6.24 tree now.  Bah)
>>>>
>>> MY config file for test:
>>> -----cut---
>> Hi,
>> config the CONFIG_NF_CONNTRACK_AMANDA=m, reboot , still oops, but this
>> time the point is nf_conntrack_ftp_init, (I doubt the
>> nf_conntrack_core is not initialized.)
>>
>> boot with vga_ask and select 80x60, copyed more infomations:
>> ---------pre oops:-----------
>> sysctl table check failed: /net/netfilter/nf_conntrack_generic_timeout
>> .3.19.13 Missing strategy
>> ...
>> nf_conntrack_14_proto_sctp4 protocol register failed
>> ...
>> ---------oops:----------------
>> divide error: 0000 [#1] SMP
>> EIP: 0060: [<c088477b>] EFLAGS 00010246
>> Process swapper
>> ...
>> nf_conntrack_ftp_init
>> ...
>>
>> Code: <...>
>> EIP <...> helper_hash +0x1b/0x24
> 
> Does not Oops here but is broken.

My $0.02:
http://www.fi.muni.cz/~xslaby/sklad/panics/nf_oops.png
http://www.fi.muni.cz/~xslaby/sklad/panics/nf_oops.config

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
