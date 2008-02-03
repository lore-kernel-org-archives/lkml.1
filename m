Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbYBCKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbYBCKxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 05:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYBCKxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 05:53:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:21883 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbYBCKxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 05:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UQtfS6p956ZE5Xs94xdh2E67gndSUPYyl4u86LHfxn/E3zDGRdTdkqmkJ84tTIisOMpyTdcJz7+hQB0JqWDHeWX0AEgPPYMS+F8rNaZBDpYCZ7IpxIAF6CTC/fnM4zoVch+PQ9LMwEwTOayCmdegQ83SDVHIFiTJuU7qVAGxz0E=
Message-ID: <84144f020802030253y596ca557w3a44a8601a13596d@mail.gmail.com>
Date: Sun, 3 Feb 2008 12:53:02 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, jens.axboe@oracle.com, James.Bottomley@steeleye.com,
       andrea@suse.de, clameter@sgi.com, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com, willy@linux.intel.com,
       "Zach Brown" <zach.brown@oracle.com>
In-Reply-To: <20080203095252.GA11043@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070728012128.GB10033@linux-os.sc.intel.com>
	 <20080203095252.GA11043@wotan.suse.de>
X-Google-Sender-Auth: 6267fc591cd81dc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Feb 3, 2008 11:52 AM, Nick Piggin <npiggin@suse.de> wrote:
> +asmlinkage void smp_call_function_fast_interrupt(void)
> +{

[snip]

> +       while (!list_empty(&list)) {
> +               struct call_single_data *data;
> +
> +               data = list_entry(list.next, struct call_single_data, list);
> +               list_del(&data->list);
> +
> +               data->func(data->info);
> +               if (data->wait) {
> +                       smp_mb();
> +                       data->wait = 0;

Why do we need smp_mb() here (maybe add a comment to keep
Andrew/checkpatch happy)?

                        Pekka
