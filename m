Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbYETVln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbYETVln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbYETVlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:41:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17110 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703AbYETVle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:41:34 -0400
Date: Tue, 20 May 2008 14:41:15 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
	groups lockdep-friendly
Message-ID: <20080520214115.GF26609@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080520163320.025971210@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520163320.025971210@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 06:33:20PM +0200, Louis Rilling wrote:
> The following patches fix lockdep warnings resulting from (correct) recursive
> locking in configfs.
> 
> Current lockdep annotations for inode mutexes in configfs are lockdep-friendly
> provided that:
> 1/ config_groups have at most one level of default groups (see
>    configfs_attach_group()),
> 2/ config_groups having default groups are never removed (see
>    configfs_detach_prep()).
> 
> Since lockdep does not handle such correct recursion, the idea is to insert
> lockdep_off()/lockdep_on() for inode mutexes as soon as the level of recursion
> of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency pattern increases.

	Hmm, this is definitely a more readable solution than the
previous, but I'm also with Arjan that it's scary :-)

Joel

-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
