Return-Path: <linux-kernel-owner+w=401wt.eu-S1750974AbXCYA3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbXCYA3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 20:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXCYA3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 20:29:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXCYA3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 20:29:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=v4xyKKUbkdlI5r9v/bJ2xQbOEz9kzOj11M8mcVUjXvP605qPsqWOBrtuiN0/pdeGD
	DHb4e8/GGkW43npQUPADg==
Message-ID: <b040c32a0703241729w9586ea2m7481f6b8cf3d24d2@mail.gmail.com>
Date: Sat, 24 Mar 2007 17:29:38 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] max_loop limit
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, "Tomas M" <tomas@slax.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460236CE.1030303@slax.org>
	 <20070322110058.GB23664@tatooine.rebelbase.local>
	 <46026A92.4020106@slax.org>
	 <20070322144210.73dfaf83.dada1@cosmosbay.com>
	 <Pine.LNX.4.61.0703230232320.9555@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> @@ -1383,7 +1380,7 @@ int loop_unregister_transfer(int number)
>
>         xfer_funcs[n] = NULL;
>
> -       for (lo = &loop_dev[0]; lo < &loop_dev[max_loop]; lo++) {
> +       list_for_each_entry(lo, &loop_devices, lo_list) {
>                 mutex_lock(&lo->lo_ctl_mutex);

Don't you need to use loop_devices_lock to protect the linked list here?


> +static struct loop_device *loop_find_dev(unsigned int number)
> +{
> +       struct loop_device *lo;
> +       list_for_each_entry(lo, &loop_devices, lo_list)
> +               if (lo->lo_number == number)
> +                       return lo;
> +       return NULL;

Here too with spin lock??
