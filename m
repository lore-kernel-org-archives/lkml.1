Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZEOL2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZEOL2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZEOL2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:28:34 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38656 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZEOL2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:28:33 -0400
Message-ID: <4A0D51DF.4020108@in.ibm.com>
Date: Fri, 15 May 2009 16:58:31 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: Next May 13:[drivers/base/firmware*] Bug while booting on x86
References: <20090513164832.c8a0de7d.sfr@canb.auug.org.au>  <4A0AC5E6.2010402@in.ibm.com> <1242316467.3393.14.camel@macbook.infradead.org>
In-Reply-To: <1242316467.3393.14.camel@macbook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Oops. Does this fix it?
>
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -328,7 +328,7 @@ firmware_data_write(struct kobject *kobj, struct
> bin_attribute *bin_attr,
>
>  		memcpy(page_data + page_ofs, buffer, page_cnt);
>
> -		kunmap(page_data);
> +		kunmap(fw_priv->pages[page_nr]);
>  		buffer += page_cnt;
>  		offset += page_cnt;
>  		count -= page_cnt;
Thanks David. This patch fixed the issue.

Tested-by : Sachin Sant <sachinp@in.ibm.com>

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

