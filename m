Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbYEDINu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbYEDINu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYEDINb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:13:31 -0400
Received: from ag-out-0708.google.com ([72.14.246.240]:22484 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbYEDINT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XBbbRGLnnZsfwfWcNNQUmXlk6kMEPwqFzGGcDHYFP5gbJn6NS4PPRpoHH5azfTHZENLw1yhU3lsIATSdpGQuoZ+its7hzu0V14BdtcbfqYUZBeM6eyvriQ0ft4hL8gspQiZuLEV/py8gxGfs4D/96M6K8qnijajtbw2auGtm5JM=
Message-ID: <a8e1da0805040113n59155fa7y7e0a016afca8ee86@mail.gmail.com>
Date: Sun, 4 May 2008 16:13:18 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH -mm] __ratelimit rewrite
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080504.005433.98511912.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504070738.GA11832@darkstar.te-china.tietoenator.com>
	 <20080504.005433.98511912.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 3:54 PM, David Miller <davem@davemloft.net> wrote:
> From: Dave Young <hidave.darkstar@gmail.com>
>  Date: Sun, 4 May 2008 15:07:38 +0800
>
>  Hi Dave,
>
>
>  > @@ -76,8 +76,8 @@ extern void warn_on_slowpath(const char
>  >       unlikely(__ret_warn_once);                              \
>  >  })
>  >
>  > -#define WARN_ON_SECS(condition, state, secs)                 \
>  > -             WARN_ON((condition) && __ratelimit(state))
>  > +#define WARN_ON_RATELIMIT(condition, state)                  \
>  > +             WARN_ON((condition) && __ratelimit(state));
>  >
>  >  #ifdef CONFIG_SMP
>  >  # define WARN_ON_SMP(x)                      WARN_ON(x)
>
>  Are you sure you want that new semicolon there?

David, thanks for your review. Will fix.

>
>         if (foo)
>                 WARN_ON_RATELIMIT(...);
>         else
>
>  will result in a compile error.
>
