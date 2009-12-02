Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZLBXmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZLBXmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbZLBXmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:42:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40115
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991AbZLBXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:42:13 -0500
Date: Wed, 02 Dec 2009 15:42:20 -0800 (PST)
Message-Id: <20091202.154220.118775778.davem@davemloft.net>
To: sbrabec@suse.cz
Cc: zambrano@broadcom.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH][stable] b44 WOL setup: one-bit-off stack corruption
 kernel panic fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1259764520.8709.293.camel@hammer.suse.cz>
References: <1259761547.8709.264.camel@hammer.suse.cz>
	<1259764520.8709.293.camel@hammer.suse.cz>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Brabec <sbrabec@suse.cz>
Date: Wed, 02 Dec 2009 15:35:20 +0100

> Stanislav Brabec wrote:
>> About 50% of shutdowns of b44 Ethernet adapter ends by kernel panic with
>> kernels compiled with stack-protector.
>> 
>> Checking b44_magic_pattern() return values, one call of
>> b44_magic_pattern() returns 127. It means, that set_bit(128, pmask) was
>> called on line 1509. It means that bit 0 of 17th byte of pmask was
>> overwritten. But pmask has only 16 bytes. Stack corruption happens.
>>  
>> It seems that set_bit() on line 1509 always writes one bit off.
>> 
>> The fix does not only solve the stack corruption, but also makes Wake On
>> LAN working on my onboard B44 on Asus A7V-333X mainboard.
>> 
>> It seems that this problem affects all kernel versions since commit
>> 725ad800 on 2006-06-20.
> 
> stable@kernel.org may be interested as well. Adding Cc:.

netdev@vger.kernel.org is even more interested.  Please post all
networking patches CC:'d there so they get properly logged
and tracked in patchwork.

Thank you.
