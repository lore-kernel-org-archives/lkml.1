Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYFTXVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYFTXVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 19:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbYFTXUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 19:20:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64747 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbYFTXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 19:20:53 -0400
Date: Fri, 20 Jun 2008 16:15:12 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oracle.com
Subject: Re: [RFC][PATCH v2] configfs: Provide variants of
	config_*_init_type_name() that report errors
Message-ID: <20080620231512.GG21416@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oracle.com
References: <1213974251-21603-1-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213974251-21603-1-git-send-email-louis.rilling@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 05:04:11PM +0200, Louis Rilling wrote:
>  void config_item_init_type_name(struct config_item *item,
>  				const char *name,
>  				struct config_item_type *type)
>  {
> -	config_item_set_name(item, name);
> -	item->ci_type = type;
> -	config_item_init(item);
> +	int error;
> +
> +	error = config_item_init_type_long_name(item, name, type);
> +	BUG_ON(error);
>  }

	This needs to BUG_ON(strlen(name) >= CONIFG_ITEM_NAME_LEN) at
the top.  We don't want to allow an invalid construct just because
memory happened to be available :-)
	Also, update Documentation/filesystems/configfs/configfs.txt.

Joel

-- 

 "I'm living so far beyond my income that we may almost be said
 to be living apart."
         - e e cummings

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
