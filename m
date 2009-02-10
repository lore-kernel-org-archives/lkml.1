Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZBJHru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZBJHru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 02:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZBJHrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 02:47:39 -0500
Received: from smtp.nokia.com ([192.100.122.230]:63038 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZBJHri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 02:47:38 -0500
Message-ID: <499130DF.2090104@nokia.com>
Date: Tue, 10 Feb 2009 09:46:39 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Federico Cuello <fedux@lugmen.org.ar>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] write-back: fix break condition
References: <1233977610-8919-1-git-send-email-fedux@lugmen.org.ar> <20090209152140.aa3f50aa.akpm@linux-foundation.org>
In-Reply-To: <20090209152140.aa3f50aa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Feb 2009 07:46:38.0452 (UTC) FILETIME=[B48DFB40:01C98B53]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> -                     if (nr_to_write > 0)
>> +                     if (nr_to_write > 0) {
>>                               nr_to_write--;
>> -                     else if (wbc->sync_mode == WB_SYNC_NONE) {
>> -                             /*
>> -                              * We stop writing back only if we are not
>> -                              * doing integrity sync. In case of integrity
>> -                              * sync we have to keep going because someone
>> -                              * may be concurrently dirtying pages, and we
>> -                              * might have synced a lot of newly appeared
>> -                              * dirty pages, but have not synced all of the
>> -                              * old dirty pages.
>> -                              */
>> -                             done = 1;
>> -                             break;
>> +                             if (nr_to_write == 0 && wbc->sync_mode == WB_SYNC_NONE) {
>> +                                     /*
>> +                                      * We stop writing back only if we are not
>> +                                      * doing integrity sync. In case of integrity
>> +                                      * sync we have to keep going because someone
>> +                                      * may be concurrently dirtying pages, and we
>> +                                      * might have synced a lot of newly appeared
>> +                                      * dirty pages, but have not synced all of the
>> +                                      * old dirty pages.
>> +                                      */
>> +                                     done = 1;
>> +                                     break;
>> +                             }
>>                       }
>>
>>                       if (wbc->nonblocking && bdi_write_congested(bdi)) {
> 
> Artem, Nick, please check?

I have not tested it, but it looks OK to me.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
