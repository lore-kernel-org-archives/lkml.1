Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZGFXMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZGFXMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZGFXMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:12:24 -0400
Received: from main.gmane.org ([80.91.229.2]:54459 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZGFXMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:12:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: Possible memory leak in fs/sysfs/bin.c
Date: Mon, 6 Jul 2009 23:12:13 +0000 (UTC)
Message-ID: <loom.20090706T230728-669@post.gmane.org>
References: <b0943d9e0907061530u2d375fe5x91f92cfee3166c91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 24.169.237.222 (Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1) Gecko/20090624 Firefox/3.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Catalin Marinas <catalin.marinas <at> arm.com> writes:


> --- a/fs/sysfs/bin.c
> +++ b/fs/sysfs/bin.c
> @@ -164,6 +164,7 @@ static ssize_t write(struct file *file, const char
> __user *userbuf,
>  	mutex_lock(&bb->mutex);
> 
>  	memcpy(bb->buffer, temp, count);
> +	kfree(temp);

Does the kfree() need to be inside the mutex_lock? Otherwise looks OK to me.

Parag




