Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbZAAOpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbZAAOpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 09:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZAAOpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 09:45:04 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:13103 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756224AbZAAOpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 09:45:02 -0500
Message-ID: <495CD6E8.1020606@panasas.com>
Date: Thu, 01 Jan 2009 16:44:56 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] exofs: osd Swiss army knife
References: <4947BFAA.4030208@panasas.com>	<1229439174-30492-1-git-send-email-bharrosh@panasas.com>	<20081229122959.2cb48cf7.akpm@linux-foundation.org>	<495B90D5.5090903@panasas.com> <20081231112645.b1867977.akpm@linux-foundation.org>
In-Reply-To: <20081231112645.b1867977.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jan 2009 14:44:55.0921 (UTC) FILETIME=[8349D610:01C96C1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 31 Dec 2008 17:33:41 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Andrew Morton wrote:
>>>> +int prepare_get_attr_list_add_entry(struct osd_request *req,
>>>> +				    uint32_t page_num,
>>>> +				    uint32_t attr_num,
>>>> +				    uint32_t attr_len)
>>>> +{
>>>> +	struct osd_attr attr = {
>>>> +		.page = page_num,
>>> Kernel developers expect a field called "page" to have type `struct
>>> page *'.  osd_attr.page is thus designed to confuse.
>>>
>>>> ...
>>>>
>> Rant below (can be ignored):
>>   This single fix will cause a massive change to the open-osd
>>   initiator patchset, (18 patches), and resubmission .I made the mistake
>>   because this name originates from a file that all naming conventions
>>   are taken from the OSD standard text. However this is no excuse
>>   for using a well known Kernel construct name. I will fix it. And
>>   will be more careful in the future.
> 
> The world wouldn't end if you left the code as-is.  We've done worse things :)

To late I've changed it. I had an Internet outage yesterday so I've only just
pushed the new trees.

I'm glad. Because I found in exofs code, inside the same file, an "u32 page"
next to a "struct page *page" which is really bad. Now attr_page everywhere
is much clearer.

[ As usual:
    git-clone git://git.open-osd.org/linux-open-osd.git linux-next-exofs
  or on the web at:
    http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/linux-next-exofs
]

I will submit another round of patches once I address all the other comments.

Thanks
Boaz
