Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbXLDIeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbXLDIeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXLDIdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:33:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52150
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbXLDIdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:33:52 -0500
Date: Tue, 04 Dec 2007 00:33:52 -0800 (PST)
Message-Id: <20071204.003352.120654801.davem@davemloft.net>
To: julia@diku.dk
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] arch/sparc: Add missing of_node_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0712022104110.3361@ask.diku.dk>
References: <Pine.LNX.4.64.0712022104110.3361@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 2 Dec 2007 21:05:24 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> There should be an of_node_put when breaking out of a loop that iterates
> using for_each_node_by_type.
> 
> This was detected and fixed using the following semantic patch.
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> identifier d;
> type T;
> expression e;
> iterator for_each_node_by_type;
> @@
> 
> T *d;
> ...
> for_each_node_by_type(d,...)
>   {... when != of_node_put(d)
>        when != e = d
> (
>    return d;
> |
> +  of_node_put(d);
> ?  return ...;
> )
> ...}
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, but I had to fixup the trailing whitespace on this line:

> -		if (!err)
> +		if (!err) {			 

As indicated by GIT:

Adds trailing whitespace.
diff:9:		if (!err) {			 
warning: 1 line adds whitespace errors.

Please correct these kinds of errors before submitting in
the future, thanks.
