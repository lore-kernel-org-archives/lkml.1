Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbYBRURR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbYBRURR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbYBRUQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:16:33 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:50502 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761265AbYBRUQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:16:30 -0500
Date: Mon, 18 Feb 2008 12:14:53 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/7] fs/ocfs2: Use BUG_ON
Message-ID: <20080218201453.GA22671@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <Pine.LNX.4.64.0802171855070.28055@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802171855070.28055@ask.diku.dk>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 06:55:49PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
> side-effects to allow a definition of BUG_ON that drops the code completely.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @ disable unlikely @ expression E,f; @@
> 
> (
>   if (<... f(...) ...>) { BUG(); }
> |
> - if (unlikely(E)) { BUG(); }
> + BUG_ON(E);
> )
> 
> @@ expression E,f; @@
> 
> (
>   if (<... f(...) ...>) { BUG(); }
> |
> - if (E) { BUG(); }
> + BUG_ON(E);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
