Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbYCTX7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbYCTX7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758830AbYCTX4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61948 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091AbYCTX4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=FlbCqQX3jBjeouPIvEEq/Dwwb0LfTmN86OMRJyDscDF5X7vNv4O4j+yPQDUspe4L9j7JNtXTkzwfLCSEdLyx2LDuCjfLQJXb6CfMMjOfAiIfL8mXtPIctC80yq+OEq18dyM2bJqy5edfUkiXHq1WU/ZHd4GQEF4ys52MoEWlCQU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 13/17] ide-tape: remove pipelined mode tape control flags
Date: Fri, 21 Mar 2008 01:09:44 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-14-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-14-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.44607.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied

> @@ -1832,14 +1822,6 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
>  		}
>  	}
>  
> -	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> -		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
> -			tape->measure_insert_time = 1;
> -			tape->insert_time = jiffies;
> -			tape->insert_size = 0;
> -			tape->insert_speed = 0;
> -		}
> -	}

It is !test_bit() so the second 'if ()' block should be preserved
(I fixed this while merging the patch).
