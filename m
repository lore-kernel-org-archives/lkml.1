Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYBRTgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYBRTgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYBRTgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:36:31 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:34150 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYBRTga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:36:30 -0500
Date: Mon, 18 Feb 2008 11:36:11 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/6] fs/ocfs2: Use DIV_ROUND_UP
Message-ID: <20080218193611.GY22671@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <Pine.LNX.4.58.0802141614400.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0802141614400.1185@pc-041.diku.dk>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 04:15:17PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
> (d)) but is perhaps more readable.
> 
> An extract of the semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @haskernel@
> @@
> 
> #include <linux/kernel.h>
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> (
> - (n + d - 1) / d
> + DIV_ROUND_UP(n,d)
> |
> - (n + (d - 1)) / d
> + DIV_ROUND_UP(n,d)
> )
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> - DIV_ROUND_UP((n),d)
> + DIV_ROUND_UP(n,d)
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> - DIV_ROUND_UP(n,(d))
> + DIV_ROUND_UP(n,d)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
