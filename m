Return-Path: <linux-kernel-owner+w=401wt.eu-S1766009AbXF1XJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766009AbXF1XJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765187AbXF1XJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:09:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61953 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbXF1XJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:09:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rJKt7NSvWitiHLP22VFaGKDdYruZCcGPigfiaoLy7WU7ReHFy46RYnIdu4oYf5d8S
	ri7YeTf1szOnOVwmCg8iQ==
Message-ID: <6599ad830706281609jebd82sdc1fb3ccc2d2df7b@mail.gmail.com>
Date: Thu, 28 Jun 2007 19:09:05 -0400
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix for bad lock balance in Containers
Cc: "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bharata@linux.vnet.ibm.com
In-Reply-To: <20070626050011.GA12584@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070626050011.GA12584@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>
> There are a few questions I had with respect to the current code,
>
> Why is the increment of s_active dependent on the return value of
> simple_set_mnt?

I think it's because, as you observed, grab_super() is static and
hence not reachable from container.c. But I thought that the only side
effect of it that we needed (since we had a safe pointer to the
superblock not obtained via the superblock list) was the increment of
sb_active. (As it turns out I was wrong and we needed the s_umount
lock too).

Incrementing the sb_active count (if simple_set_mnt() failed) seemed
as though it would be wrong.

>
> What should be the correct approach to get the locking balance? As far
> as I can see, the correct method would be to call sget which would then
> correctly handle everything. But that would require a test function. I
> saw functionality similar to a test function in the beginning of
> container_get_sb(). Should that be seperated and put in a seperate test
> function so that sget can be called?

I don't quite remember why I did it this way originally, now. I've got
no objection to the code being cleaned up to fit the more common
approach if it's practical to do so, but it seems to me that your
current patch fix seems enough at least for now.

Thanks,

Paul
