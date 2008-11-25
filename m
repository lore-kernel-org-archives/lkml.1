Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYKYOam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYKYOam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYKYOae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:30:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:11473 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYKYOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xXNLD7eTjt2kk2Vl/R52n7vlFahOYDOh2s/APYTI5VZuLJ5Z+3FjHsD8RNI5PFhyBl
         vnp+en8SqnLyWiyfNkLBZrLraPnsbsN/S1YLVwuCe9IGEktm+JbCFJ1FGoVjvPqRy4+X
         plssG3g8Tl4vg3e751QSxYzBRKPgDC1kx+WPs=
Message-ID: <2f11576a0811250630i1d668factccde119def9ff341@mail.gmail.com>
Date: Tue, 25 Nov 2008 23:30:32 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
       akpm@linux-foundation.org
In-Reply-To: <492BFE6F.5090902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081124145057.4211bd46@bree.surriel.com>
	 <20081125203333.26F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <492BFE6F.5090902@redhat.com>
X-Google-Sender-Auth: 5fd6a2d4c4a43531
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/25 Rik van Riel <riel@redhat.com>:
> KOSAKI Motohiro wrote:
>>>
>>> Sometimes the VM spends the first few priority rounds rotating back
>>> referenced pages and submitting IO.  Once we get to a lower priority,
>>> sometimes the VM ends up freeing way too many pages.
>>>
>>> The fix is relatively simple: in shrink_zone() we can check how many
>>> pages we have already freed, direct reclaim tasks break out of the
>>> scanning loop if they have already freed enough pages and have reached
>>> a lower priority level.
>>>
>>> However, in order to do this we do need to know how many pages we already
>>> freed, so move nr_reclaimed into scan_control.
>>>
>>> Signed-off-by: Rik van Riel <riel@redhat.com>
>>> ---
>>> Kosaki, this should address the zone scanning pressure issue.
>>
>> hmmmm. I still don't like the behavior when priority==DEF_PRIORITY.
>> but I also should explain by code and benchmark.
>
> Well, the behaviour when priority==DEF_PRIORITY is the
> same as the kernel's behaviour without the patch...


Yes, but I think it decrease this patch's valueable...



>> therefore, I'll try to mesure this patch in this week.
>
> Looking forward to it.

thank you.
