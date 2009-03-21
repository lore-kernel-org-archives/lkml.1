Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZCUWOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZCUWOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZCUWO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:14:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:9170 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbZCUWO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:14:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KOJ9OY1ZjoFbds65oeTXWLvSkxhF9pcz/DKqe+u3uhpBQTvd/TmcvROC4phlaKkxh0
         9xg+L0iL5RycmHdKzA6UI1nl+RA9tEG/0wqB7iLQcqIHZL7ZrpikDIo+07fEC0/vjiqc
         PFjB3NrN+arS7nRYEi96uCHt3cclMF+w38qu0=
MIME-Version: 1.0
In-Reply-To: <49C53CC0.5060303@zytor.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com>
	 <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
	 <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com>
	 <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>
	 <49C45159.8020503@zytor.com>
	 <e9c3a7c20903210819r222cd4acwb466d2a11d3388f6@mail.gmail.com>
	 <49C53CC0.5060303@zytor.com>
Date: Sat, 21 Mar 2009 15:14:24 -0700
X-Google-Sender-Auth: f69aa6d96866af45
Message-ID: <e9c3a7c20903211514p60fda2fbhc5039c16f708e81d@mail.gmail.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 
	multiplication
From: Dan Williams <dan.j.williams@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ilya Yanok <yanok@emcraft.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "neilb@suse.de" <neilb@suse.de>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Yuri Tikhonov <yur@emcraft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 12:15 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Why does it?  I don't see why you'd need to cover the vector-vector case
> at all, since it doesn't appear anywhere in the algorithms.  Certainly
> going backwards from a vector-vector set to derive if you can do a
> scalar-vector multiply when you should have known that in the first
> place is not really useful.
>
>>
>> Looking closer, the only other caller, async_pq_zero_sum, can be
>> deleted because it has no users.  So async_pq can become a static
>> routine in async_r6recov.
>>
>
> That's another issue entirely, of course :)
>

...ah, but now I see your point and the root cause of the problem.
The caller needs to be modified to only require scalar multiplication
even in this corner case.

Thanks,
Dan
