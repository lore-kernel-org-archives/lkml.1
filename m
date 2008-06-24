Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbYFXRLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbYFXRLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbYFXRLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:11:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11791 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438AbYFXRLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:11:12 -0400
Date: Tue, 24 Jun 2008 10:10:51 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: configfs: Q: item leak in a failing configfs_attach_group()?
Message-ID: <20080624171051.GD4184@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080624141649.GH7621@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624141649.GH7621@hawkmoon.kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 04:16:49PM +0200, Louis Rilling wrote:
> Hi,
> 
> I'd like an opinion on the following scenario:
> 
> process 1: 					process 2:
> configfs_mkdir("A")
>   attach_group("A")
>     attach_item("A")
>       d_instantiate("A")
>     populate_groups("A")
>       mutex_lock("A")
>       attach_group("A/B")
>         attach_item("A")
>           d_instantiate("A/B")
> 						mkdir("A/B/C")
> 						  do_path_lookup("A/B/C", LOOKUP_PARENT)

					This has to sleep until
					configfs_mkdir("A") finishes.
					It's waiting on A->d_parent's
					i_mutex, which is held by
					sys_mkdirat().

Joel

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
