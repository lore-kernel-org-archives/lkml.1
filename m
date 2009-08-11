Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZHKTbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZHKTbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZHKTbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:31:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39188 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZHKTbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:31:11 -0400
Date: Tue, 11 Aug 2009 15:15:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wl1271: fix compiler warnings on 64 bit archs
Message-ID: <20090811191518.GI2634@tuxdriver.com>
References: <1249981107-21746-1-git-send-email-luciano.coelho@nokia.com> <20090811200746.cde6aed9.sfr@canb.auug.org.au> <4A81BB47.2020607@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A81BB47.2020607@nokia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 09:41:11PM +0300, Luciano Coelho wrote:
> ext Stephen Rothwell wrote:
>> Hi Luciano,
>>
>> On Tue, 11 Aug 2009 11:58:27 +0300 Luciano Coelho <luciano.coelho@nokia.com> wrote:
>>   
>>> +++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
>>> @@ -100,8 +100,8 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
>>>   	wl1271_debug(DEBUG_BOOT, "starting firmware upload");
>>>  -	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d", 
>>> fw_data_len,
>>> -		CHUNK_SIZE);
>>> +	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d",
>>> +		     (u32) fw_data_len, CHUNK_SIZE);
>>>     
>>
>> fw_data_len is a size_t and so should be printed with %zd.
>>
>>   
>>> @@ -148,7 +148,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
>>>  	addr = dest + chunk_num * CHUNK_SIZE;
>>>  	p = buf + chunk_num * CHUNK_SIZE;
>>>  	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%d B) 0x%p to 0x%x",
>>> -		     fw_data_len % CHUNK_SIZE, p, addr);
>>> +		     (u32) fw_data_len % CHUNK_SIZE, p, addr);
>>>     
>>
>> ditto.
>>   
>
> Thanks! I didn't know about the z length modifier for printf (everyday  
> learning something new!), I should have checked the manpage.  I'll fix  
> this and send v2 of my patch.

I've got it fixed-up already...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
