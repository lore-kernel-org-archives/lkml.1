Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbZKYUsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbZKYUsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933459AbZKYUsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:48:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933224AbZKYUsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:48:38 -0500
Message-ID: <4B0D97F9.70106@redhat.com>
Date: Wed, 25 Nov 2009 15:47:53 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, lwoodman@redhat.com,
       kosaki.motohiro@fujitsu.co.jp, Tomasz Chmielewski <mangoo@wpkg.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] vmscan: do not evict inactive pages when skipping an
 active list scan
References: <20091125133752.2683c3e4@bree.surriel.com> <20091125203509.GA18018@cmpxchg.org>
In-Reply-To: <20091125203509.GA18018@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 03:35 PM, Johannes Weiner wrote:
> Hello all,
>
> On Wed, Nov 25, 2009 at 01:37:52PM -0500, Rik van Riel wrote:
>    
>> In AIM7 runs, recent kernels start swapping out anonymous pages
>> well before they should.  This is due to shrink_list falling
>> through to shrink_inactive_list if !inactive_anon_is_low(zone, sc),
>> when all we really wanted to do is pre-age some anonymous pages to
>> give them extra time to be referenced while on the inactive list.
>>      
> I do not quite understand what changed 'recently'.
>
> That fall-through logic to keep eating inactives when the ratio is off
> came in a year ago with the second-chance-for-anon-pages patch..?
>
>    
The confusion comes from my use of the word
"recently" here.  Larry started testing with
RHEL 5 as the baseline.

And yeah - I believe the code may well have
been wrong ever since it was merged. The
indentation just looked so pretty that noone
spotted the bug.

> Acked-by: Johannes Weiner<hannes@cmpxchg.org>
>
>    
Thank you.
