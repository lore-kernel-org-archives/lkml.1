Return-Path: <linux-kernel-owner+w=401wt.eu-S964944AbYBGVZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbYBGVZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbYBGVYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:24:21 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:3001 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934912AbYBGVYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m4ERo11CXILYpDZ3sxlsMrUqInwTzIRFTN6oF8jI6FyUgEibEEFZPm1BkNY4dkrcHNIgOkkMwN+H2HCQg0lUSTH/z9MLHWOjcj0+yzJj0I6wSKVBVp4t85r9bgLdkzc3HUQRel8iGBTQAlID8Qg+YHzgGXH5MO6/PAGMcCah01I=
Message-ID: <ecb4efd10802071324n3582fdfai3154a3a488ade2fd@mail.gmail.com>
Date: Thu, 7 Feb 2008 16:24:15 -0500
From: "Clem Taylor" <clem.taylor@gmail.com>
To: "Ulisses Furquim" <ulissesf@gmail.com>
Subject: Re: inotify_add_watch() returning ENOSPC in 2.6.24 [watch descriptor leak?]
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Amy Griffis" <amy.griffis@hp.com>
In-Reply-To: <d23110170802071054s6fef54c9q182a9ed2e180052@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ecb4efd10802051749n6a626e84k3ac8210aa2b5a446@mail.gmail.com>
	 <20080206015103.9a0f4069.akpm@linux-foundation.org>
	 <ecb4efd10802061140g929e699y8d79f1317c30478d@mail.gmail.com>
	 <d23110170802071054s6fef54c9q182a9ed2e180052@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 1:54 PM, Ulisses Furquim <ulissesf@gmail.com> wrote:
> Ok, I had a go with it and found the problem. We weren't releasing
> one-shot watches because the test for them was wrong. We're using the
> event's mask to test for one-shot watches when we should've been using
> the watch's mask.

Thanks, this patch seems to fix the problem.

                                --Clem
