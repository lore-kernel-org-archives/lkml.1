Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0BKLP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 06:15:26 -0500
Received: from mail-qy0-f190.google.com ([209.85.221.190]:57838 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0BKLPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 06:15:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Neq9/mGAJdkrwFzZ6rVX0jWftPQCUZkUyXIbkufTavxC5tplQDSZ0rEHlno6nYvy48
         4cnqRi+e0QtuQVcfGhMtitW/5rigs0j/WG3eghTqllJqE/o2t3R+zT5yVYgzSt9n2WTC
         Z42VNrPrcaeU4bgPWspDOqbi5NK0Y2ZkJdCNc=
MIME-Version: 1.0
In-Reply-To: <201002111546.35036.knikanth@suse.de>
References: <201002091659.27037.knikanth@suse.de>
	 <20100211051341.GA13967@localhost>
	 <201002111304.54742.knikanth@suse.de>
	 <201002111546.35036.knikanth@suse.de>
Date: Thu, 11 Feb 2010 16:45:24 +0530
Message-ID: <d24465cb1002110315x4af18888na55aa8d61478e094@mail.gmail.com>
Subject: Re: [PATCH v2] Make VM_MAX_READAHEAD a kernel parameter
From: Ankit Jain <radical@gmail.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __init readahead(char *str)
> +{
> +       if (!str)
> +               return -EINVAL;
> +       vm_max_readahead_kb = memparse(str, &str) / 1024ULL;

Just wondering, shouldn't you check whether the str had a valid value
[memparse (str, &next); next > str ..] and if it didn't, then use the
DEFAULT_VM_MAX_READAHEAD ? Otherwise, incase of a invalid
value, the readahead value will become zero.

> +       default_backing_dev_info.ra_pages = vm_max_readahead_kb
> +                                               * 1024 / PAGE_CACHE_SIZE;
> +       return 0;
> +}
> +
> +early_param("readahead", readahead);
> +

-Ankit
