Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZKCVLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZKCVLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZKCVLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:11:07 -0500
Received: from mail.crca.org.au ([67.207.131.56]:43142 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZKCVLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:11:06 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AF09CB2.9030500@crca.org.au>
Date: Wed, 04 Nov 2009 08:12:18 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 2/5] vmscan: Kill hibernation specific reclaim logic
 and unify it
References: <20091102000855.F404.A69D9226@jp.fujitsu.com> <20091103002520.886C.A69D9226@jp.fujitsu.com> <4AEF4CF1.3020500@crca.org.au> <200911031230.20344.rjw@sisk.pl>
In-Reply-To: <200911031230.20344.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

Rafael J. Wysocki wrote:
> On Monday 02 November 2009, Nigel Cunningham wrote:
>> Hi.
> 
> Hi,
> 
>> KOSAKI Motohiro wrote:
>>>> I haven't given much thought to numa awareness in hibernate code, but I
>>>> can say that the shrink_all_memory interface is woefully inadequate as
>>>> far as zone awareness goes. Since lowmem needs to be atomically restored
>>>> before we can restore highmem, we really need to be able to ask for a
>>>> particular number of pages of a particular zone type to be freed.
>>> Honestly, I am not suspend/hibernation expert. Can I ask why caller need to know
>>> per-zone number of freed pages information? if hibernation don't need highmem.
>>> following incremental patch prevent highmem reclaim perfectly. Is it enough?
>> (Disclaimer: I don't think about highmem a lot any more, and might have
>> forgotten some of the details, or swsusp's algorithms might have
>> changed. Rafael might need to correct some of this...)
>>
>> Imagine that you have a system with 1000 pages of lowmem and 5000 pages
>> of highmem. Of these, 950 lowmem pages are in use and 500 highmem pages
>> are in use.
>>
>> In order to to be able to save an image, we need to be able to do an
>> atomic copy of those lowmem pages.
>>
>> You might think that we could just copy everything into the spare
>> highmem pages, but we can't because mapping and unmapping the highmem
>> pages as we copy the data will leave us with an inconsistent copy.
> 
> This isn't the case any more for the mainline hibernate code.  We use highmem
> for storing image data as well as lowmem.

Highmem for storing copies of lowmem pages?

Regards,

Nigel
