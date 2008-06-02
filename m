Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYFBXIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYFBXIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYFBXHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:07:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11787 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYFBXHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:07:54 -0400
Date: Mon, 2 Jun 2008 16:07:21 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/4] configfs: Make multiple default_group
	destructions lockdep friendly
Message-ID: <20080602230721.GD19500@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20080522114048.265996107@kerlabs.com> <20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4836F48A.70008@kerlabs.com>
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

	A couple comments.
	First, put a BUG_ON() where you have BAD BAD BAD - we shouldn't
be creating a depth we can't delete.

> @@ -392,6 +437,10 @@ static int configfs_detach_prep(struct d
>  			 * deep nesting of default_groups
>  			 */
>  			ret = configfs_detach_prep(sd->s_dentry);
> +			/* Update parent's lock_level so that remaining
> +			 * sibling children keep on globally increasing
> +			 * lock_level */
> +			copy_dirent_lock_level(sd, parent_sd);
>  			if (!ret)
>  				continue;
>  		} else

	I'm not sure I get this hunk.  If our parent was 1 and we are 2,
we are copying 2 to our parent so the parent can only have other
children at 3?

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
