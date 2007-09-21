Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXIUJrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXIUJrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbXIUJrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:47:09 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:43139 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753743AbXIUJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:47:08 -0400
Message-ID: <46F39319.9090705@moving-picture.com>
Date: Fri, 21 Sep 2007 10:47:05 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arvin Moezzi <moezzia@gmail.com>
CC: linux-kernel@vger.kernel.org, aarapov@redhat.com,
       akpm@linux-foundation.org, hpa@zytor.com
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
References: <E1IXziD-0003YJ-0w@moving-picture.com> <3402120c0709201856j58c3775bq8dc7886785a11344@mail.gmail.com>
In-Reply-To: <3402120c0709201856j58c3775bq8dc7886785a11344@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arvin Moezzi wrote:
> 2007/9/19, James Pearson <james-p@moving-picture.com>:
> 
>>+       while (count > 0) {
>>+               int this_len, retval;
>>+
>>+               this_len = mm->env_end - (mm->env_start + src);
>>+
>>+               if (this_len <= 0)
>>+                       break;
>>+
>>+               if (this_len > max_len)
>>+                       this_len = max_len;
>>+
>>+               retval = access_process_vm(task, (mm->env_start + src),
>>+                       page, this_len, 0);
>>+
>>+               if (retval <= 0) {
>>+                       ret = retval;
>>+                       break;
>>+               }
>>+
>>+               if (copy_to_user(buf, page, retval)) {
> 
>                                                                 ^^^^
> shouldn't you only copy min(count,retval) bytes? otherwise you could
> write beyond the users buffer "buf", right?

AFAIK, 'retval' can never be greater than 'this_len', which can never be 
greater than 'max_len', which can never be greater than 'count'

James Pearson
