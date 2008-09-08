Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbYIHJvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbYIHJvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYIHJv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:51:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:48311 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYIHJv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HyJ6Q/AkWfDAyAnB9gAaRFwwzGO3CY3M4dQbKcr7U/VrDhTlS0AybtEcgoXG+Mkhso
         BZVag9l9Vp3hnrxMcVlgIuh14/lp+k+aBRnnbkAevkYQyVr5BwPJBjHXjay9eRIvU1Rm
         OttUTyqMVcu2XKQbt3DOGQ+rIIcG1dwdafQhc=
Message-ID: <ee6a1e220809080251h4f8b1d1bnbc7af37f31cd2834@mail.gmail.com>
Date: Mon, 8 Sep 2008 13:21:24 +0330
From: "hamidreza jahanjou" <hamid.jahanjou@gmail.com>
To: "Li Yu" <raise.sail@gmail.com>
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48C4A0FF.8070705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48BFCECE.90103@gmail.com> <48C4A0FF.8070705@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/8, Li Yu <raise.sail@gmail.com>:
> And the linear searching for whole address space of a vma is not good
> idea too, really.
>
>> +	    if (!page_allowed_in_cluster(cursor_page, ci))
>> +		continue;
>>

Thank you for the review and comments. You are right in that searching
the whole process address space is not a good idea. The idea is to
make the scan range flexible, thus normally, assuming that the code
has been well-tuned, only a very limited number of VMA's are scanned.

In general, i think that the cluster size and the scan range should be
tuned depending on the backing storage characteristics and the
low-on-memory severity. Like any VM code, this one needs tuning.

BTW, the code could be implemented much more elegantly if the VMA's
were connected using a doubly-linked list. I wonder if there are
enought other codes with the same situation to justify making it
doubly-linked.
