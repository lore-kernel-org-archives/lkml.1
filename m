Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYEDHyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYEDHyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYEDHyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:54:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35023
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbYEDHyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:54:35 -0400
Date: Sun, 04 May 2008 00:54:33 -0700 (PDT)
Message-Id: <20080504.005433.98511912.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] __ratelimit rewrite
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080504070738.GA11832@darkstar.te-china.tietoenator.com>
References: <20080504070738.GA11832@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Sun, 4 May 2008 15:07:38 +0800

Hi Dave,

> @@ -76,8 +76,8 @@ extern void warn_on_slowpath(const char 
>  	unlikely(__ret_warn_once);				\
>  })
>  
> -#define WARN_ON_SECS(condition, state, secs)			\
> -		WARN_ON((condition) && __ratelimit(state))
> +#define WARN_ON_RATELIMIT(condition, state)			\
> +		WARN_ON((condition) && __ratelimit(state));
>  
>  #ifdef CONFIG_SMP
>  # define WARN_ON_SMP(x)			WARN_ON(x)

Are you sure you want that new semicolon there?

	if (foo)
		WARN_ON_RATELIMIT(...);
	else

will result in a compile error.
