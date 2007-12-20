Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbXLTXVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbXLTXVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbXLTXVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:21:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51123
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756051AbXLTXVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:21:22 -0500
Date: Thu, 20 Dec 2007 15:21:21 -0800 (PST)
Message-Id: <20071220.152121.188610437.davem@davemloft.net>
To: horms@verge.net.au
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, apw@us.ibm.com
Subject: Re: Update ip command line processing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071218085730.GA10765@verge.net.au>
References: <20071218085730.GA10765@verge.net.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Tue, 18 Dec 2007 17:57:32 +0900

> @@ -1414,9 +1414,16 @@ late_initcall(ip_auto_config);
>   */
>  static int __init ic_proto_name(char *name)
>  {
> +	if (!name) {
> +		return 1;
> +	}

I do not see any circumstance under which this pointer can
be NULL.  Judging by your other changes, I think you mean
to use "!*name" here.

Maybe:

	if (*name == '\0')

would make it clearer what you're checking for, an
empty string.

Otherwise I'm fine with your change.
