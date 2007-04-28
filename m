Return-Path: <linux-kernel-owner+w=401wt.eu-S1031036AbXD1EOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031036AbXD1EOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 00:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031049AbXD1EOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 00:14:05 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:36150 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031036AbXD1EOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 00:14:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=S/UDVt5YBm9faYRjVdbndX/vHG18r5JK5vqYPUOIzmmZbPJPTsYBRJa/d4Cw/fE7Yq/V4SidH/wI0TvLIvfnlvwGMAw04wWW381I/y98+/wIEN3oVxPP+zY0uwEKhBwpgdu+a/OjMGDBTknoreYkSnqxX+zSSCNtVIcy39i/S/M=  ;
X-YMail-OSG: XnDO1LYVM1n8QPMJ90na8vRiTUc.w7xB4K3s32eZnihGNeSeBL0A6oJVg4c0c4bM8GmI0iupvQ--
Message-ID: <4632CA04.6040706@yahoo.com.au>
Date: Sat, 28 Apr 2007 14:13:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Giridhar Pemmasani <pgiri@yahoo.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow __vmalloc with GFP_ATOMIC
References: <539764.53941.qm@web32409.mail.mud.yahoo.com>
In-Reply-To: <539764.53941.qm@web32409.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giridhar Pemmasani wrote:
> Until 2.6.19, __vmalloc with GFP_ATOMIC was possible, but __get_vm_area_node
> would allocate the node itself with GFP_KERNEL, causing a warning. In 2.6.19,
> this was "fixed" by using the same flags that were passed to __vmalloc also
> in __get_vm_area_node. However, __get_vm_area_node does
> BUG_ON(in_interrupt()) now, since vmlist_lock is obtained without disabling
> bottom-half's. The patch below uses bh disabled lock for vmlist_lock, so that
> __vmalloc can be used in interrupt context.
> 
> In 2.6.21, __vmalloc with GFP_ATOMIC is used by arch/um/kernel/process.c;
> __vmalloc is also used in ntfs, xfs, but it is not clear to me if they use it
> with GFP_ATOMIC or GFP_KERNEL.
> 
> Thanks,
> Giri

Hi Giri,

I'm sure I've read the reason for this one before, but when you do patches
like these, can you include that reason in the changelog please?

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
