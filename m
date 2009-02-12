Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbZBLFC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbZBLFC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 00:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbZBLFCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 00:02:17 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:28188 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZBLFCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:02:16 -0500
MIME-Version: 1.0
In-Reply-To: <4990DF7C.1090701@kernel.org>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
	 <20090204212517.GM22608@elte.hu> <498A206A.2070309@kernel.org>
	 <4990DF7C.1090701@kernel.org>
Date: Wed, 11 Feb 2009 21:02:13 -0800
Message-ID: <9ae48b020902112102m2b75e68codc3083285bd2f9@mail.gmail.com>
Subject: Re: [PATCH] x86/pci: host mmconfig detect clean up v3
From: Ed Swierk <eswierk@aristanetworks.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jbarnes@virtuousgeek.org, Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 5:59 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Impact: not assume one place for mmconfig in nb
>
> prepare for following case: amd fam10h + mcp55
> CPU MSR has some range, mcp55 pci config will have another one.
>
> also prepare for mcp55 + io55 system. every one will have one range.
>
> if it s mcp55 detect duties to execlude range that is used by CPU MSR
> aka, if CPU state bus 0-255, range in mcp55 need to be dropped.
> because HW in CPU will not route that mcp55 mmconfig to handle it.
>
> v2: fix e7520 exit path
> v3: make it could support
>   PCI MMCONFIG 0 [00-3f]
>   PCI MMCONFIG 0 [40-7f]
>   PCI MMCONFIG 0 [80-ff]
>
> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

Looks okay to me. I tested the patch on a board with an AMD 0Fh CPU
and one MCP55, no ACPI.

--Ed
