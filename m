Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXCKVj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXCKVj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbXCKVj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:39:29 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:59905 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932700AbXCKVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:39:28 -0400
Message-ID: <45F4770F.4090902@gmail.com>
Date: Sun, 11 Mar 2007 22:39:27 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>  <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com>  <20070303094125.838ce04d.akpm@linux-foundation.org>  <45F13791.8040408@gmail.com> <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com> <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz> <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina napsal(a):
> On Fri, 9 Mar 2007, Jiri Kosina wrote:
> 
>> If this is present also in vanilla and not only in -mm, could you please 
>> try reverting commits 4237081e573b99a48991aa71364b0682c444651c and 
>> d4ae650a904612ffb7edd3f28b69b022988d2466 and let me know if the 
>> situation gets any better?
> 
> Hi Jiri,
> 
> or even better, does the patch below (against 2.6.21-rc3) fix the problem 
> with your keyboard? I can see possibilities of report fields unaligned to 
> the byte boundary, which this might be causing problems.
> 
> (the original patch author added to cc)
> 
> Thanks.
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index f4ee1af..f571513 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -873,10 +873,6 @@ static void hid_output_field(struct hid_field *field, __u8 *data)
>  	unsigned size = field->report_size;
>  	unsigned n;
>  
> -	/* make sure the unused bits in the last byte are zeros */
> -	if (count > 0 && size > 0)
> -		data[(offset+count*size-1)/8] = 0;
> -
>  	for (n = 0; n < count; n++) {
>  		if (field->logical_minimum < 0)	/* signed values */
>  			implement(data, offset + n * size, size, s32ton(field->value[n], size));
> 

No, this doesn't help -- -rc3-mm2 minus this behaves exactly the same. -rc3 
without this patch too.

Going to try to revert the commits mentioned above.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
