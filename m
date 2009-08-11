Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZHKSll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZHKSll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZHKSlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:41:40 -0400
Received: from smtp.nokia.com ([192.100.105.134]:44459 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbZHKSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:41:39 -0400
Message-ID: <4A81BB47.2020607@nokia.com>
Date: Tue, 11 Aug 2009 21:41:11 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wl1271: fix compiler warnings on 64 bit archs
References: <1249981107-21746-1-git-send-email-luciano.coelho@nokia.com> <20090811200746.cde6aed9.sfr@canb.auug.org.au>
In-Reply-To: <20090811200746.cde6aed9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2009 18:41:14.0465 (UTC) FILETIME=[4E107510:01CA1AB3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Stephen Rothwell wrote:
> Hi Luciano,
>
> On Tue, 11 Aug 2009 11:58:27 +0300 Luciano Coelho <luciano.coelho@nokia.com> wrote:
>   
>> +++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
>> @@ -100,8 +100,8 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
>>  
>>  	wl1271_debug(DEBUG_BOOT, "starting firmware upload");
>>  
>> -	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d", fw_data_len,
>> -		CHUNK_SIZE);
>> +	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d",
>> +		     (u32) fw_data_len, CHUNK_SIZE);
>>     
>
> fw_data_len is a size_t and so should be printed with %zd.
>
>   
>> @@ -148,7 +148,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
>>  	addr = dest + chunk_num * CHUNK_SIZE;
>>  	p = buf + chunk_num * CHUNK_SIZE;
>>  	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%d B) 0x%p to 0x%x",
>> -		     fw_data_len % CHUNK_SIZE, p, addr);
>> +		     (u32) fw_data_len % CHUNK_SIZE, p, addr);
>>     
>
> ditto.
>   

Thanks! I didn't know about the z length modifier for printf (everyday 
learning something new!), I should have checked the manpage.  I'll fix 
this and send v2 of my patch.

-- 
Cheers,
Luca.

