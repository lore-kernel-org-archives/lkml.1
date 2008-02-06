Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbYBFUTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbYBFUTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbYBFUTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:19:09 -0500
Received: from www17.your-server.de ([213.133.104.17]:44401 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbYBFUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:19:08 -0500
Message-ID: <47AA1633.4000309@m3y3r.de>
Date: Wed, 06 Feb 2008 21:18:59 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Latest kernel doesn't boot
References: <1202249704.47a8dfe89a99c@213.133.104.17> <47A8E427.6040205@zytor.com>
In-Reply-To: <47A8E427.6040205@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin schrieb:
> thomas@m3y3r.de wrote:
>> The latest linux kernel doesn't boot on my computer
>> (h=21511abd0a248a3f225d3b611cfabb93124605a7).
>>
>> elilo hangs while booting this kernel. 2.6.24 works.
>
> Wow, so we know it's affected with EFI, since you're using elilo.
>
> You gave absolutely zero other information about your system or what 
> "doesn't boot" mean.
Here is an older bisection try:
$ git bisect log

git-bisect start
# bad: [dd430ca20c40ecccd6954a7efd13d4398f507728] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86
git-bisect bad dd430ca20c40ecccd6954a7efd13d4398f507728
# good: [49914084e797530d9baaf51df9eda77babc98fa8] Linux 2.6.24
git-bisect good 49914084e797530d9baaf51df9eda77babc98fa8
# good: [f4d900a2cae94256f56be7769734100c7054bf00] [NETLINK]: Mark 
attribute construction exception unlikely
git-bisect good f4d900a2cae94256f56be7769734100c7054bf00
# good: [85040bcb4643cba578839e953f25e2d1965d83d0] [IPV6] ADDRLABEL: Fix 
double free on label deletion.
git-bisect good 85040bcb4643cba578839e953f25e2d1965d83d0
# good: [70fd93c9d9e07dd2ea4465df76a0ddd414fd21ac] x86: export cpu_gdt_descr
git-bisect good 70fd93c9d9e07dd2ea4465df76a0ddd414fd21ac
# bad: [306c142f99caef5a30a0d61a39a956c069941b63] x86: pat: e820 cleanup
git-bisect bad 306c142f99caef5a30a0d61a39a956c069941b63
# bad: [7271339347653f6d652bb47aaee1f57d936002f6] x86: 
arch/x86/kernel/cpu/mcheck/k7.c checkpatch fixes
git-bisect bad 7271339347653f6d652bb47aaee1f57d936002f6
# bad: [7818a1e0294debee02d5135e17b89f28b8871887] x86: provide 64-bit 
with a load_sp0 function.
git-bisect bad 7818a1e0294debee02d5135e17b89f28b8871887
# bad: [2215e69d2cf5024647f9a034807990590d25dd4e] x86 boot: use E820 
memory map on EFI 32 platform
git-bisect bad 2215e69d2cf5024647f9a034807990590d25dd4e
# good: [26048d75e8d6c840742468667f4a7ab8c2df74c9] x86: use the same 
data type for tls_array.
git-bisect good 26048d75e8d6c840742468667f4a7ab8c2df74c9
# good: [341d8854d38fe6e7655f7748babae5c25a51aa70] x86: remove fastcall 
from include/asm-x86
git-bisect good 341d8854d38fe6e7655f7748babae5c25a51aa70
# good: [8c8b8859b64baf6d7c33900e8720c7bafe775b2c] mcheck mce_64: 
mce_read_sem to mutex
git-bisect good 8c8b8859b64baf6d7c33900e8720c7bafe775b2c
# good: [de18c850af701ac9512b7239e88fa45e4c168771] x86: EFI runtime 
service support: EFI runtime services
git-bisect good de18c850af701ac9512b7239e88fa45e4c168771
# bad: [e429795c68d3001ecae74f6465420c9f043b0ece] x86: EFI runtime 
service support: remove duplicated code from efi_32.c
git-bisect bad e429795c68d3001ecae74f6465420c9f043b0ece
# good: [9ad65e4748f55e3159283d7fa9d54fb30c086113] x86: EFI runtime 
service support: document for EFI runtime services
git-bisect good 9ad65e4748f55e3159283d7fa9d54fb30c086113


I can not revert the commit e429795c68d3001ecae74f6465420c9f043b0ece. it 
gave me errors.
but i'm also not sure what could be wrong with this commit!

my first idea was that the commit 
"[2215e69d2cf5024647f9a034807990590d25dd4e] x86 boot: use E820 memory 
map on EFI 32 platform" is the offender, because the macbook pro doesn't 
provide a e820 memory map at all. but bisect showed that i'm wrong here?!

confused greeting
thomas

