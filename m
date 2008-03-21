Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbYCUAAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbYCUAAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758601AbYCTX4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbYCTX4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=W+YWb6SsNMBUgp12YfWlCqNBNhywcE/88EZYJddJusG09cXeTY8E9d4NbnCvPrae2X7/q7NuLqF8xE6TSY5yoV8ZTS/XtAAbVQC59C0M7ehbztJHyr4VY5t8rHCTXYrRWzWsphA3YHKphE16UbFDVfdyqXHCdQJb8zedK7483p0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 11/17] ide-tape: remove pipeline-specific code from idetape_setup
Date: Fri, 21 Mar 2008 01:09:41 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-12-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-12-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.41404.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 17 March 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

->max_stages and ->{min,max}_pipeline are later removed in patch #14,
it makes sense to merge both patches together [ as I did ;-) ]

[...]

> -	if (tape->max_stages == 0) {
> -		tape->max_stages   = 1;
> -		tape->min_pipeline = 1;
> -		tape->max_pipeline = 1;
> -	}
> -
> -	t1 = (tape->stage_size * HZ) / (speed * 1000);
> -	tmid = (*(u16 *)&tape->caps[16] * 32 * HZ) / (speed * 125);
> -	tn = (IDETAPE_FIFO_THRESHOLD * tape->stage_size * HZ) / (speed * 1000);
> -
> -	if (tape->max_stages)
> -		t = tn;
> -	else
> -		t = t1;
> +	t = (tape->stage_size * HZ) / (speed * 1000);

tape->max_stages was always > 0 so 't' should use 'tn' not 't1'
(fixed during merge)
