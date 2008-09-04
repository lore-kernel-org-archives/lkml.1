Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYIDXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYIDXYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYIDXYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:24:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:50351 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYIDXYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=TvTao3PLFEFSCNevO6PxLzWE8rSLROg7YpqqKsA77tEaCFHg5MX0yY6JDgzsf3GVIw
         SnDfgmHe4SGDI9mQBvhgcWBn7gey8xlQ2Rbb6H/gk9XV/wBdePfwK/dATLVZMw1muoht
         sFqtLHG/Etnc41k1EBhog3L5ic7FlYh1Nuflg=
Message-ID: <e9c3a7c20809041624o24af57fsbe58507a44e6e2ef@mail.gmail.com>
Date: Thu, 4 Sep 2008 16:24:04 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Ilya Yanok" <yanok@emcraft.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, wd@denx.de, yur@emcraft.com
In-Reply-To: <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
	 <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
X-Google-Sender-Auth: 332374fbe1ea1422
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 2:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu,  4 Sep 2008 01:43:51 +0400
> Ilya Yanok <yanok@emcraft.com> wrote:
>
>> From: Yuri Tikhonov <yur@emcraft.com>
>>
>> Should clear the next pointer of the TX if we are sure that the
>> next TX (say NXT) will be submitted to the channel too. Overwise,
>> we break the chain of descriptors, because we lose the information
>> about the next descriptor to run. So next time, when invoke
>> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
>> NXT will be never submitted.
>>
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>
> This patch should include your signed-off-by: as well.  Because you
> were on the delivery path, as described in
> Documentation/SubmittingPatches, section 12.
>

Yes, Ilya once I have your signed-off-by I will push this to Linus and
-stable.  As far as impact for in-tree drivers: iop13xx by is immune,
iop3xx can hit this, and it looks like the orion5x implementation is
immune since copy and xor are available on the same channel.

--
Dan
