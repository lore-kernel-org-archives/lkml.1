Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZKKVJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZKKVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbZKKVJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:09:56 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53389 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbZKKVJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:09:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Kg0uWimhNo8M4O+x9ecS8ZTgY1bb7DWxR4OREAO4twTEXcZB7w4XY1msOgpBUnOPdO
         zCtY1Men5VmlZa+24FQ2x0sQPwed/iwEF01yPcl6oMknWgxmJlBajQni9mAIL8bW8vOh
         m1OrPwydyA/77UHex31+vk37ugLZuNQVFtrok=
Message-ID: <4AFB2822.30906@gmail.com>
Date: Wed, 11 Nov 2009 15:09:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Anton D. Kachalov" <mouse@mayc.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
References: <4AFACC03.7080209@mayc.ru>
In-Reply-To: <4AFACC03.7080209@mayc.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 08:36 AM, Anton D. Kachalov wrote:
> Hello everyone!
>
> I've found strange behavior of reading /dev/mem:
>
> for i in 0 1 2; do
> echo $i
> dd if=/dev/mem of=/dev/null skip=$((6+$i)) bs=$((0x20000000)) count=1
> done
>
> On some systems with Supermicro X8DTU I've got several messages during
> first 512Mb starting from 0xc000_0000:
>
> "BUG: soft lockup - CPU#xx stuck for 61s!"
>
> On other systems with the sameboard I've stuck without any errors at
> last 10Mb before 0x1_0000_0000. Local APIC access?
>
> On E5440 (Dell PowerEdge 1950) I've just got several:
> APIC error on CPU3: 00(80)
> APIC error on CPU3: 80(80)
> ...
> APIC error on CPU3: 80(80)
> That looks like wrong register access.

I don't think that we prevent any access to device registers in /dev/mem 
- if you read something that has side effects and something breaks, well 
I guess you get to keep both pieces :-) There's a reason it's root-only..
