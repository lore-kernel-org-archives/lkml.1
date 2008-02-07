Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbYBGUsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbYBGUsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYBGUsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:48:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbYBGUsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:48:20 -0500
Date: Thu, 7 Feb 2008 12:47:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [git patches] ocfs2 update
Message-Id: <20080207124745.4868e108.akpm@linux-foundation.org>
In-Reply-To: <20080207200944.GQ22671@ca-server1.us.oracle.com>
References: <20080207200944.GQ22671@ca-server1.us.oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 12:09:44 -0800
Mark Fasheh <mark.fasheh@oracle.com> wrote:

>  /*
> - * dlm_register_domain: one-time setup per "domain"
> + * Compare a requested locking protocol version against the current one.
> + *
> + * If the major numbers are different, they are incompatible.
> + * If the current minor is greater than the request, they are incompatible.
> + * If the current minor is less than or equal to the request, they are
> + * compatible, and the requester should run at the current minor version.
> + */
> +static int dlm_protocol_compare(struct dlm_protocol_version *existing,
> +				struct dlm_protocol_version *request)
> +{
> +	if (existing->pv_major != request->pv_major)
> +		return 1;
> +
> +	if (existing->pv_minor > request->pv_minor)
> +		return 1;
> +
> +	if (existing->pv_minor < request->pv_minor)
> +		request->pv_minor = existing->pv_minor;
> +
> +	return 0;
> +}
> +

It's somewhat obnoxious that what appears to be a straightforward
compare-two-things-and-return-result function will actually modify one of
the things which it is allegedly comparing.

Please integrate checkpatch into your processes - this one had a few little
glitches.

