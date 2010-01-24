Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057Ab0AXQfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0AXQfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974Ab0AXQfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:35:14 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:63101 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0AXQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:35:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=l5C1rmXxsTXOayZEi6dYSHzPR1qMvetn5WZKcMuAzfXdmll8qTiHNtAe3brRQQp8dq
         k3cDQgQByE5Y6nbgD3yPbobP3hUExr2jxsHKplHaNnxTb7fsU1j6mDIV25LAfvBEP3Sk
         lALfUGifrngu9xL/QxJcO81LWYAK/1m+qepbM=
Message-ID: <4B5C76B8.4090700@gmail.com>
Date: Sun, 24 Jan 2010 17:35:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] media: dvb/af9015, implement eeprom hashing
References: <4B4F6BE5.2040102@iki.fi> <1264173055-14787-1-git-send-email-jslaby@suse.cz> <4B5C7258.1010605@iki.fi>
In-Reply-To: <4B5C7258.1010605@iki.fi>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2010 05:16 PM, Antti Palosaari wrote:
>> +    af9015_config.eeprom_sum = 0;
>> +    for (reg = 0; reg<  eeprom_size / sizeof(u32); reg++) {
>> +        af9015_config.eeprom_sum *= GOLDEN_RATIO_PRIME_32;
>> +        af9015_config.eeprom_sum += le32_to_cpu(((u32 *)eeprom)[reg]);
>> +    }
>> +
>> +    deb_info("%s: eeprom sum=%.8x\n", __func__,
>> af9015_config.eeprom_sum);
> 
> Does this sum contain all 256 bytes from EEPROM? 256/4 is 64.

Yes it does. It is computed as a hashed sum of 32-bit numbers (4 bytes)
-- speed (does not matter) and larger space of hashes. Hence the
division by 4. The cast does the trick: ((u32 *)eeprom)[reg] -- reg
index is on a 4-byte basis.

regards,
-- 
js
