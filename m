Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbYEMGHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbYEMGHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbYEMGHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:07:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:42042 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbYEMGHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:07:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Kfg876a9+5W3QiYWV0Ht7iqgOPJCd7MpzUyU3uQYwvlw823H/7p1wFHVBTkmLlQ5pZ/dlpQUZJ05ed3rDFeluGKGEQKeEEthx0T/sFcbTcrLgLBjq+9JLJfBIhEkGCGMMcPYyZNAIUVLccALVQH3p08tHmLE45ozCdow1hkAKPY=
Message-ID: <386072610805122307p1b20a2d7ucfe821362a24a872@mail.gmail.com>
Date: Tue, 13 May 2008 14:07:37 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] [net/irda]: Fix a misalign access issue.
Cc: Graf.Yang@analog.com, marcel@holtmann.org, samuel@sortiz.org,
       irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080512.211402.33040026.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210588521-11508-1-git-send-email-cooloney@kernel.org>
	 <1210598108.16390.47.camel@violet.holtmann.net>
	 <0F1B54C89D5F954D8535DB252AF412FA0164BC89@chinexm1.ad.analog.com>
	 <20080512.211402.33040026.davem@davemloft.net>
X-Google-Sender-Auth: ef12d9998caa24ef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 12:14 PM, David Miller <davem@davemloft.net> wrote:
> From: "Yang, Graf" <Graf.Yang@analog.com>
>  Date: Tue, 13 May 2008 12:07:35 +0800
>
>
>  > I have tried
>  > struct irda_device_info {
>  >         __u32       saddr;    /* Address of local interface */
>  >         __u32       daddr;    /* Address of remote device */
>  >         char        info[22]; /* Description */
>  >         __u8        charset;  /* Charset used for description */
>  >         __u8        reserve;  /* For align data */
>  >         __u8        hints[2]; /* Hint bits */
>  > };
>  >
>  > It works with my irda driver. Can I modify it like this?
>
>  This header file and the irda_device_info datastructure are exported
>  to, and used by, userspace.
>
>  Therefore you cannot change this structure's layout without breaking
>  every single existing IRDA binary out there.
>

Exactly, so we plan to add put/get_unaligned method to fix this issue.
After Graf fix it, I will send out the patch

Thanks
-Bryan
