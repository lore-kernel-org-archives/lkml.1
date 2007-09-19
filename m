Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbXISVoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbXISVoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXISVoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:44:04 -0400
Received: from THAUM.MIT.EDU ([18.95.3.27]:48493 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751313AbXISVoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:44:03 -0400
X-Greylist: delayed 1275 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 17:44:03 EDT
Message-ID: <46F19326.1040503@myrealbox.com>
Date: Wed, 19 Sep 2007 17:22:46 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       kernel1@cyberdogtech.com
Subject: Re: A little coding style nugget of joy
References: <20070919123401.9369534d.kernel1@cyberdogtech.com> <p73odfyvar1.fsf@bingen.suse.de>
In-Reply-To: <p73odfyvar1.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Matt LaPlante <kernel1@cyberdogtech.com> writes:
> 
>> Since everyone loves random statistics, here are a few gems to give you a break from your busy day:
>>
>> Number of lines in the 2.6.22 Linux kernel source that include one or more trailing whitespaces: 135209
>> Bytes saved by removing said whitespace: 151809
> 
> You don't actually save anything on disk on most file systems
> (essentially everything except reiserfs on current Linux)
> because all files are rounded to block size (normally 4K) 
> 
> Same in page cache.

This is a terrible assumption in general (i.e. if filesize % blocksize 
is close to uniformly distributed).  If you remove one byte and the data 
is stored with blocksize B, then you either save zero bytes with 
probability 1-1/B or you save B bytes with probability 1/B.  The 
expected number of bytes saved is B*1/B=1.  Since expectation is linear, 
if you remove x bytes, the expected number of bytes saved is x (even if 
there is more than one byte removed per file).

In my tree, about half of the files have size >= 4k, so the assumption 
is probably not _that_ far off the mark.

Alternatively, there are an average of about 16 bytes removed per file, 
and there are 11 which are <= 16 bytes short of a 4k boundary, so it's 
not at all unreasonable that we'd save 40-50k.

> 
> And in tar files bzip2/gzip is very good at compacting them.

That's true.

--Andy
