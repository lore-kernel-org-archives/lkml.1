Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYLCOde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYLCOde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLCOdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:33:24 -0500
Received: from mail.tmr.com ([64.65.253.246]:55219 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYLCOdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:33:23 -0500
Message-ID: <49369872.20406@tmr.com>
Date: Wed, 03 Dec 2008 09:32:18 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081112 Fedora/1.1.13-1.fc9 pango-text SeaMonkey/1.1.13
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: roel kluin <roel.kluin@gmail.com>, tytso@mit.edu, adilger@sun.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious unsigned
 wrap
References: <49343AD9.4020606@gmail.com> <20081202220510.ddef1115.akpm@linux-foundation.org>
In-Reply-To: <20081202220510.ddef1115.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 01 Dec 2008 14:28:25 -0500 roel kluin <roel.kluin@gmail.com> wrote:
>
>   
>> Fix loop, with obvious unsigned wrap
>>
>>     
>
> Please raise separate patches for ext3 and ext4 - their paths into the
> tree are different.
>
>   
>> --- a/fs/ext3/namei.c
>> +++ b/fs/ext3/namei.c
>> @@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>>  	/* Split the existing block in the middle, size-wise */
>>  	size = 0;
>>  	move = 0;
>> -	for (i = count-1; i >= 0; i--) {
>> +	for (i = count; i--; ) {
>>     
>
> So we're replacing an accidental for(;;) with something which can
> really terminate.  This is potentially a functional change, and it's
> perhaps telling us that we should replace it with a real for (;;) loop
> anyway.
>   
It's not a "for (;;)" loop, because the index value does change, but 
clearly in the current implementation the termination condition won't be 
met by any index value. You still need to bail on index value, and the 
index is used in the loop.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


