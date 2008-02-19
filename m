Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYBSWEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYBSWEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762000AbYBSWEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:04:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:1634 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761815AbYBSWD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:03:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PwO/QZcoelvzu0F+2sqfly+Ms7QMcb3CunjZmeupevZ2VNWmRPRlXqHNxC3C7NDcV47HITjW8O86cAzRgfRXbsBdwv3KqG2h78aFeb+/UwfuFtY63T2KilMbE6cfKFf33eFaV7wu67ShlaY8GR4uFKAWS3fQygFXD6qCyeNkd0c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-cd: remove the internal 64k buffer
Date: Tue, 19 Feb 2008 22:51:36 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080219143247.GA3980@gollum.tnic>
In-Reply-To: <20080219143247.GA3980@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192251.37183.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 19 February 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's one more item from my TODO list. The removal is straight forward, after
> testing it with all my cdrom drives they all seem even to rotate quieter due to
> the automatic speed adjustment of the drive to the continuous data stream
> bandwidth in contrast to the buffer-mode in which recurring buffer-fill speedups
> caused the drive's read speeed to spike in order to keep the buffer filled up
> constantly.
> 
> Still, i'd keep this a bit longer in -mm to see whether there are some
> other issues with it and with all the different workloads.
> 
> 
> commit a855bd5d94ddac678cf90b4b8f20dbd3ac8ea29a
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Tue Feb 19 14:25:09 2008 +0100
> 
>     ide-cd: remove the internal 64k buffer
>     
>     This removes the internal ide-cd buffer and falls back to read-ahead block layer
>     capabilities. Thorough testing (cd burning, dvd read, raw read) gives with the
>     bufferless mode marginally better performance in addition to simplified code.
>     
>     bufferless:
>     
>     dd: reading `/dev/hdc': Input/output error
>     6238+0 records in
>     6238+0 records out
>     204406784 bytes (204 MB) copied, 259.891 s, 787 kB/s
>     
>     real    4m21.598s
>     user    0m0.014s
>     sys     0m0.744s
>     
>     with the old buffer (2.6.25-rc1):
>     
>     dd: reading `/dev/hdc': Input/output error
>     6238+0 records in
>     6238+0 records out
>     204406784 bytes (204 MB) copied, 262.893 s, 778 kB/s
>     
>     real    4m22.938s
>     user    0m0.009s
>     sys     0m0.771s
>     
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied, thanks
