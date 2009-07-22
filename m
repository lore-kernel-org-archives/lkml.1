Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZGVHYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZGVHYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 03:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZGVHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 03:24:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:41622 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZGVHYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 03:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sei+ZmIONKzpgU6Lj9bgUWEs2seqvq/heZlk4dH45vM71NAZUZXps4RLSjQ4FVCq6v
         2H/ZgzqMkcXeEGgte5sQ14sdKyd6zFo1BhTxhhX9Ej3k8ZAO2HoBC2Vhj290vsCHuTyc
         Dd4J/qcjM7c20kWYDbLCHFCDM7E8hDmiGym6M=
Message-ID: <4A66BEAD.3080404@gmail.com>
Date: Wed, 22 Jul 2009 09:24:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org
Subject: Re: Do cpu-endian MMIO accessors exist?
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <200907212315.50225.arnd@arndb.de> <4A663987.4040500@gmail.com> <200907220005.27583.arnd@arndb.de>
In-Reply-To: <200907220005.27583.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2009 12:05 AM, Arnd Bergmann wrote:
> On Tuesday 21 July 2009, Jiri Slaby wrote:
>> I guess it's a bug that ioread/write* on sh are not with
>> barriers?
> 
> That depends on how that architecture defines its bus interface.
> On many simple architectures, you do not need any synchronization
> operations.

No, I should have written this explicitly. I meant read* have a barrier,
whereas ioread* do not. Similarly for writes. Is this expected?

For example:
#define __raw_readl(a) (__chk_io_ptr(a), *(volatile u32 __force *)(a))
#define readl(a)       ({ u32 r_ = __raw_readl(a); mb(); r_; })
#define ioread32(a)    __raw_readl(a)
