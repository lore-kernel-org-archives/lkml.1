Return-Path: <linux-kernel-owner+w=401wt.eu-S934920AbXHJLVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934920AbXHJLVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760110AbXHJLVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:21:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:54250 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbXHJLVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=m8DeDu3tdYJNqZ44f/x7tWn0blMujTJL8ud7cGnC+EOn2+VQbhtboL7LkooNYnjDnUZQkhK8yULlWcl+E+IpO7sBBgbPmw0QyiXfzwcQXkTF157XD+NYB22g6mv7raYtdPkUKyB38CGTV32wuHPLXJmuTOU80q/hgHFAZBXYFp8=
Message-ID: <46BC49C3.6020100@googlemail.com>
Date: Fri, 10 Aug 2007 13:19:31 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>	 <a8e1da0708100118r779068i64ffdc11e452be9b@mail.gmail.com>	 <20070810013210.1b2f121c.akpm@linux-foundation.org>	 <a8e1da0708100137t48c5c673vf0c98fb5f0cd058b@mail.gmail.com> <a8e1da0708100252g5597da63j9cb665ade26f7654@mail.gmail.com>
In-Reply-To: <a8e1da0708100252g5597da63j9cb665ade26f7654@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
>> On 8/10/07, Dave Young <hidave.darkstar@gmail.com> wrote:
>>> On 8/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Fri, 10 Aug 2007 16:18:38 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
>>>
>>>> Hi,
>>>> 2.6.23-rc2-mm2:
>>>> config with CONFIG_NF_CONNTRACK_AMANDA=y
>>>> boot  oops:
>>>>
>>>> hand copyed :
>>>> the EIP: helper_hash
>>>>
>>>> backtrace:
>>>> do_basic_setup
>>>> ...
>>>> nf_conntrack_amanda_init
>>>> error_code
>>>> do_vivide_error
>>>> ...
>>>>
>>> cc netdev
>>>
>>> please send config
>>>
>>> presumably nf_ct_helper_hsize is zero
>>>
>>> I'd have thought that the same bug would be present in mainline - there's
>>> nothing in git-net.patch.
>>>
>>> (hunts around, discovers that there's a net-2.6.24 tree now.  Bah)
>>>
>> MY config file for test:
>> -----cut---
> Hi,
> config the CONFIG_NF_CONNTRACK_AMANDA=m, reboot , still oops, but this
> time the point is nf_conntrack_ftp_init, (I doubt the
> nf_conntrack_core is not initialized.)
> 
> boot with vga_ask and select 80x60, copyed more infomations:
> ---------pre oops:-----------
> sysctl table check failed: /net/netfilter/nf_conntrack_generic_timeout
> .3.19.13 Missing strategy
> ...
> nf_conntrack_14_proto_sctp4 protocol register failed
> ...
> ---------oops:----------------
> divide error: 0000 [#1] SMP
> EIP: 0060: [<c088477b>] EFLAGS 00010246
> Process swapper
> ...
> nf_conntrack_ftp_init
> ...
> 
> Code: <...>
> EIP <...> helper_hash +0x1b/0x24

Does not Oops here but is broken.
Here is what I get :

modprobe nf_conntrack_amanda
WARNING: Error inserting nf_conntrack (/lib/modules/2.6.23-rc2-mm2/kernel/net/netfilter/nf_conntrack.ko): Cannot allocate memory
FATAL: Error inserting nf_conntrack_amanda (/lib/modules/2.6.23-rc2-mm2/kernel/net/netfilter/nf_conntrack_amanda.ko): Unknown symbol in module, or unknown parameter (see dmesg)

( from dmesg )

...

[ 1094.768867] nf_conntrack version 0.5.0 (10240 buckets, 40960 max)
[ 1094.769078] sysctl table check failed: /net/netfilter/nf_conntrack_generic_timeout .3.19.13 Missing strategy
[ 1094.780956] nf_conntrack_amanda: Unknown symbol nf_ct_expect_alloc
[ 1094.781055] nf_conntrack_amanda: Unknown symbol nf_ct_expect_put
[ 1094.781242] nf_conntrack_amanda: Unknown symbol nf_ct_expect_init
[ 1094.781371] nf_conntrack_amanda: Unknown symbol nf_conntrack_helper_unregister
[ 1094.781468] nf_conntrack_amanda: Unknown symbol __nf_ct_refresh_acct
[ 1094.781580] nf_conntrack_amanda: Unknown symbol nf_ct_expect_related
[ 1094.781673] nf_conntrack_amanda: Unknown symbol nf_conntrack_helper_register

...

> 
> Regards
> dave
> -


Gabriel
