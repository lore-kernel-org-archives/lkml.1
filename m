Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYIDTR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYIDTR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYIDTRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:17:18 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:46310 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYIDTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JIv18AgRFiBaOtDTrDSI6rcJm6Bqp5Npi/x6RKBPE3tKDf5VlVVBNXaBiLUTxR553e
         2wgetoOq9wuliE2uK9GWl6G6jFoLXkbPlFPNJFd5iH0U9JPJ7yZXMSIuhj9bOdA3GtOZ
         tTadOMcqoev9UCgy6PiG3b9Z/DsIKMQT5TkzI=
Message-ID: <86802c440809041217p454c4471y66a8ed6907d9cc8@mail.gmail.com>
Date: Thu, 4 Sep 2008 12:17:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 5/6] x86: move mtrr cpu cap setting early in early_init_xxxx
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       "Krzysztof Helt" <krzysztof.h1@wp.pl>
In-Reply-To: <20080904191333.GD24990@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
	 <1220312246-30879-5-git-send-email-yhlu.kernel@gmail.com>
	 <20080904191333.GD24990@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 12:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> Krzysztof Helt <krzysztof.h1@wp.pl> found mtrr is not detected on k6-2
>>
>> root case:
>>       we move mtrr_bp_init early for mtrr trimming.
>> and in early_detect, only read cap from cpuid, so some cpu doesn't have
>> that bit in cpuid and need to set workaround bit will have problem.
>>
>> need to add early_init_xxxx to preset those bit before mtrr_bp_init
>> for those earlier cpus.
>>
>> this patch is for 2.6.27
>
> hm, not sure we can do it in v2.6.27 as it depends on the other CPU init
> patches and that is a rather sensitive codepath. This problem should be
> present in v2.6.26 too, right?

Yes. old cpus without cpuid bit for mtrr need this patch...
Krzysztof Helt tested it and it works with 2.6.27-rc5 (?)


YH
