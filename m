Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYFPWez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYFPWez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756575AbYFPWer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:34:47 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57982 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbYFPWeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:34:46 -0400
Date: Mon, 16 Jun 2008 15:29:00 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH][BUGFIX] configfs: Fix symlink() to a removing item
Message-ID: <20080616222900.GD6441@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080616180911.GV30804@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080616180911.GV30804@localhost>
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

On Mon, Jun 16, 2008 at 08:09:11PM +0200, Louis Rilling wrote:
> This patch introduces a similar (weird?) behavior as with mkdir failures making
> rmdir fail: if symlink() races with rmdir() of the parent directory (or its
> youngest user-created ancestor if parent is a default group) or rmdir() of the
> target directory, and then fails in configfs_create(), this can make the racing
> rmdir() fail despite the concerned directory having no user-created entry (resp.
> no symlink pointing to it or one of its default groups) in the end.
> If this behavior is found unacceptable, I'll submit a fix in the same spirit as
> the racing mkdir() fix.

	Ahh, but you can't wait on the mutex like you do in mkdir(),
because they're not ordered - it can race rename again.

Joel
 

-- 

Dort wo man Bücher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
