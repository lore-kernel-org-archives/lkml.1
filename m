Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbYBJNgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbYBJNgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYBJNgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:36:44 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:36863 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYBJNgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:36:43 -0500
Message-ID: <47AEFDE9.7060405@web.de>
Date: Sun, 10 Feb 2008 14:36:41 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
References: <20080210071331.GC3851@elte.hu> <20080210124629.GA12200@joi>
In-Reply-To: <20080210124629.GA12200@joi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/gYW6uwjYN//P+ECkUNOIYQCYAJEl75igO73Sm
	AEwpvakQd0A4rair+DZbq6A5QsLvTsuV3Bk8POQa5+67C2BWw+
	r3PSoypWA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
> On Sun, Feb 10, 2008 at 08:13:31AM +0100, Ingo Molnar wrote:
>> +	} else {
>> +		while (count-- > 0) {
>> +			unsigned char ch;
>> +
>> +			if (probe_kernel_address(mem, ch)) {
>> +				kgdb_may_fault = 0;
>> +				return ERR_PTR(-EINVAL);
>> +			}
>> +			mem++;
>> +			*buf++ = hexchars[ch >> 4];
>> +			*buf++ = hexchars[ch & 0xf];
> use pack_hex_byte?

Good point! kgdb introduces this helper but don't use it consequently!

>> +/*
>> + * While we find nice hex chars, build a long_val.
>> + * Return number of chars processed.
>> + */
>> +int kgdb_hex2long(char **ptr, long *long_val)
>> +{
>> +	int hex_val;
>> +	int num = 0;
>> +
>> +	*long_val = 0;
>> +
>> +	while (**ptr) {
>> +		hex_val = hex(**ptr);
>> +		if (hex_val >= 0) {
>> +			*long_val = (*long_val << 4) | hex_val;
>> +			num++;
>> +		} else
>> +			break;
>> +
>> +		(*ptr)++;
>> +	}
> if (hex_val < 0)
> 	break;
> *long_val = (*long_val << 4) | hex_val;
> num++;
> (*ptr)++;

Jep, will include this in the cleanup patch I'm currently baking.

Jan
