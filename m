Return-Path: <linux-kernel-owner+w=401wt.eu-S2992578AbXDYLSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992578AbXDYLSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992687AbXDYLSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:18:08 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:37461 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992578AbXDYLSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:18:06 -0400
Message-ID: <11882.simon.1177499883@5ec7c279.invalid>
In-Reply-To: <200704250919.50382.duncan.sands@math.u-psud.fr>
References: <462E730F.3090401@simon.arlott.org.uk>
    <200704250919.50382.duncan.sands@math.u-psud.fr>
Date: Wed, 25 Apr 2007 12:18:03 +0100
Subject: Re: [PATCH] cxacru: Cleanup sysfs attribute code
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, April 25, 2007 08:19, Duncan Sands wrote:
> Hi Simon,
>
>>  static ssize_t cxacru_sysfs_showattr_dB(s16 value, char *buf)
>>  {
>> -	if (unlikely(value < 0)) {
>> -		return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
>> -						value / 100, -value % 100);
>> -	} else {
>> -		return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
>> -						value / 100, value % 100);
>> -	}
>> +	return snprintf(buf, PAGE_SIZE, "%u.%02u\n",
>> +					value / 100, abs(value) % 100);
>
> shouldn't this be "%d.%02u\n"?

Yes, I'll send an updated patch this evening, unless Andrew adds the change himself by then.

>> +	static char *str[] = { "no", "yes" };
> ...
>> +	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
>
> This could be
> 	static char *str[] = { "no\n", "yes\n" };
> ...
> 	return snprintf(buf, PAGE_SIZE, str[value]);
> I'm not saying that it's better, just a remark!

The \ns in the larger arrays were making them less readable.

-- 
Simon Arlott
