Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYIORyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYIORyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYIORyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:54:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38080 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbYIORyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:54:44 -0400
Subject: Re: [RFC v5][PATCH 2/8] General infrastructure for checkpoint
	restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
	 <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 10:54:20 -0700
Message-Id: <1221501260.16561.7.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-13 at 19:06 -0400, Oren Laadan wrote:
> 
> +int cr_read_obj_type(struct cr_ctx *ctx, void *buf, int n, int type)
> +{
> +       struct cr_hdr h;
> +       int ret;
> +
> +       ret = cr_read_obj(ctx, &h, buf, n);
> +       if (!ret) {
> +               if (h.type == type)
> +                       ret = h.parent;
> +               else
> +                       ret = -EINVAL;
> +       }
> +       return ret;
> +}

This one has been bugging me a bit.  This adds one net line of code and
I think it's much easier to read:

{
	struct cr_hdr h;
	int ret;

	ret = cr_read_obj(ctx, &h, buf, n);
	if (ret)
		return ret;

	ret = -EINVAL;	
	if (h.type == type)
		ret = h.parent;

	return ret;
}                     

-- Dave

