Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbYCBTFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbYCBTFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758942AbYCBTDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:03:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:37615 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853AbYCBTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:03:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=N8JaTLgOtrEYCNqCGPCNEA1ZvBbKOUrHUcpqum4lvB1lQELzh90t2TSs+dZRD617vybjdLQ4Z9x0rI1R52dZncp67xzYwB3qJD5O2+XD1DCws6xcg8DLdWkWvlzt4hku+NScNeu7gjTqfBfy3UGySyuwTwubGjoZF2UjM0dXAk0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 05/24] ide-tape: cleanup pipeline-specific code from idetape_init_read
Date: Sun, 2 Mar 2008 19:48:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-6-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204361928-30229-6-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021948.34386.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008, Borislav Petkov wrote:
> Also, remove idetape_kmalloc_stage() and idetape_add_stage_tail() since they've
> become unused, as a result.

I wonder whether some of these changes should be done before patch #2 or #3?

It could be that it would make patches #2-4 obvious, ie.

> -	if (!test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags) &&
> -	    tape->nr_stages < max_stages) {
> -		new_stage = idetape_kmalloc_stage(tape);
> -		while (new_stage != NULL) {
> -			new_stage->rq = rq;
> -			idetape_add_stage_tail(drive, new_stage);
> -			if (tape->nr_stages >= max_stages)
> -				break;
> -			new_stage = idetape_kmalloc_stage(tape);
> -		}
> -	}

I can see now that after this change ->first_stage will be always NULL
