Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbZEHBEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbZEHBEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZEHBEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:04:24 -0400
Received: from relay3.sgi.com ([192.48.156.57]:56766 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751452AbZEHBEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:04:23 -0400
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Message-Id: <ABCCDF18-5100-4891-AF1C-BA9513C8A334@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <4A037503.1070904@sandeen.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
Date: Thu, 7 May 2009 20:04:17 -0500
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com> <4A036FBC.9020201@sandeen.net> <4A037503.1070904@sandeen.net>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 7, 2009, at 6:55 PM, Eric Sandeen wrote:

> Eric Sandeen wrote:
>
>> there are 2 subsequent unlocks for the same inode:
>>
>> 1:
>> xfs_iunlock: ip ca2304c0 ino 132  flags 0x5
>
> ...
>
>> 2:
>> xfs_iunlock: ip ca230980 ino 131  flags 0x5
>
>
> Ugh no, those are 2 different inodes.... I can read, really.  :)   
> still,
> looking into it.

I've been chasing this as well, and I found the double xfs iolock
unlock which is causing xfs_fsr deadlock itself. I have a fix tested.
The patch is coming.

Felix

>
>
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

