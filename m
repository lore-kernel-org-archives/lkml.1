Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbXDAKQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbXDAKQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 06:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXDAKQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 06:16:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:53172 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbXDAKQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 06:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ugSASGZSCePfJNY5dMaCgnfmpNqCIYu8CT/e79YXKi9g/ZogKFkpCxq2mvUMej2O7dxqurLZ1+s3HD80ONJcDaysJ4U68bQ6wd5rh2yooLGIpN1jRwckj78BgOKWfc1isxuXzgniRUjBhWNZd9Kpp+CsD9pYSYhV+EM/XwloPZU=
Message-ID: <84144f020704010316uf9e020u1155ce300219f2ee@mail.gmail.com>
Date: Sun, 1 Apr 2007 13:16:43 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
	 <460EA727.8070306@gmail.com>
	 <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
X-Google-Sender-Auth: 1284d90df5be7cb4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Looks like mcdx_xfer is sleeping while holding q->queue_lock. The
> attached (untested) patch should fix it.

You also need to add a spin_lock_irq() before the call to
end_request() to Jens' patch.
