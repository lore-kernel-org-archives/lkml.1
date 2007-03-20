Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbXCTSHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbXCTSHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXCTSHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:07:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbXCTSHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:07:04 -0400
Message-ID: <460022B4.4000509@redhat.com>
Date: Tue, 20 Mar 2007 14:06:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061004)
MIME-Version: 1.0
To: Bob Picco <bob.picco@hp.com>
CC: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #2
References: <45FF3052.0@redhat.com> <20070320183927.GI10084@localhost>
In-Reply-To: <20070320183927.GI10084@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Picco wrote:

>> +	/*
>> + 	 *                 anon      recent_rotated_anon
>> +	 * %anon = 100 * --------- / ------------------- * IO cost
>> +	 *               anon+file   recent_scanned_anon
>> +	 */
>> +	anon_l = (anon_prio + 1) * (zone->recent_scanned_anon + 1);
>> +	do_div(anon_l, (zone->recent_rotated_anon + 1));
>> +
>> +	file_l = (file_prio + 1) * (zone->recent_scanned_file + 1);
>> +	do_div(file_l, (zone->recent_rotated_file + 1));
>> +
>> +	/* Normalize to percentages. */
>> +	*anon_percent = (unsigned long)100 * anon_l / (anon_l + file_l);
> I believe this requires a do_div on 32 bit arch. 

Actually, the "unsigned long long" is a holdover from the
code I had before.  With the calculation above, I think I
can make it a simple "unsigned long" and get rid of the
do_div magic alltogether...

Btw, it would help if you could trim your replies.  I almost
could not find your one line reply in-between the 1600 lines
of quoted text :)

-- 
All Rights Reversed
