Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYCUDgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYCUDgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 23:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYCUDgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 23:36:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:63568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYCUDgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 23:36:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=h/zS7QCi9hOyA68QftfcNqoatiCvwoIj0bmviVX0/4vTdMPfsijdmXvaJfpNGiLYd1aTGk955gO/G/oFme4+FoisljWSrKcjVKPIiZK6bMwPTDUImev4ZU0BrClya119MaEGDCAEUexcZfBXU3rYfCu2aXdWgsp18LjMFMYk/n4=
Message-ID: <3ae72650803202036i7aee418et23b1ec5ac72560f7@mail.gmail.com>
Date: Fri, 21 Mar 2008 04:36:44 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rodolfo Giometti" <giometti@linux.it>
Subject: Re: [PATCH 1/7] LinuxPPS core support.
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Jones" <davej@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Greg KH" <greg@kroah.com>, "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <12048053473401-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12048053463198-git-send-email-giometti@linux.it>
	 <12048053473401-git-send-email-giometti@linux.it>
X-Google-Sender-Auth: 3138c54f0539ea03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 1:09 PM, Rodolfo Giometti <giometti@linux.it> wrote:
> This patch adds the kernel side of the PPS support currently named
>  "LinuxPPS".

>  diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
>  new file mode 100644
>  index 0000000..c25c91c
>  --- /dev/null
>  +++ b/drivers/pps/sysfs.c
>  @@ -0,0 +1,130 @@

>  +void pps_sysfs_remove_source_entry(struct pps_device *pps)
>  +{
>  +       /* Delete info files */
>  +       sysfs_remove_group(&pps->dev->kobj, &pps_group);
>  +}
>  +
>  +int pps_sysfs_create_source_entry(struct pps_device *pps)
>  +{
>  +       int ret;
>  +
>  +       /* Create info files */
>  +       ret = sysfs_create_group(&pps->dev->kobj, &pps_group);

Any specific reason you are creating the group by hand, and not assign
it to the default group in your class? It would will let the core
handle it for you. The device add uevent to userspace will happen
before you added the attributes, which is usually not nice.

Kay
