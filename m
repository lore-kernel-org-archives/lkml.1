Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbXLYXk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbXLYXk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXLYXkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:40:41 -0500
Received: from ozlabs.org ([203.10.76.45]:36679 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLYXkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:40:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 05/16] make write() operation smp aware
Date: Wed, 26 Dec 2007 10:40:24 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com>
In-Reply-To: <11981576632726-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261040.24771.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 00:33:45 Glauber de Oliveira Costa wrote:
> --- a/drivers/lguest/lguest_user.c
> +++ b/drivers/lguest/lguest_user.c
> @@ -223,14 +223,21 @@ static ssize_t write(struct file *file, const char
...
>  	/* If you haven't initialized, you must do that first. */
> -	if (req != LHREQ_INITIALIZE && !lg)
> -		return -EINVAL;
> +	if (req != LHREQ_INITIALIZE) {
> +		if (!lg)
> +			return -EINVAL;
> +		vcpu = &lg->vcpus[vcpu_id];
> +		if (!vcpu)
> +			return -EINVAL;
> +	}

Bounds check again...

Cheers,
Rusty.
