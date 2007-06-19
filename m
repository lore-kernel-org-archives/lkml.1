Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbXFSOPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbXFSOPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXFSOPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:15:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbXFSOPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:15:35 -0400
Date: Tue, 19 Jun 2007 16:15:28 +0200
From: Karel Zak <kzak@redhat.com>
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org
Subject: Re: mount-2.12r-ggk.tar.gz
Message-ID: <20070619141528.GS7226@petra.dvoda.cz>
References: <200706191238.l5JCcxg14300@apps.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706191238.l5JCcxg14300@apps.cwi.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 02:38:59PM +0200, Andries.Brouwer@cwi.nl wrote:
> The present situation of util-linux and mount is not quite clear to me.
> On kernel.org under utils/util-linux nothing has happened for over a year,
> and there is also an empty utils/util-linux-ng.

 We use GIT for development, the utils/util-linux-ng is for releases.

  http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git
  http://userweb.kernel.org/~kzak/util-linux-ng/
  http://vger.kernel.org/vger-lists.html#util-linux-ng

> Anyway, Dirk Gerrits, René Gabriël and Peter Kooijmans sent me
> a patch to add support for shared subtrees to the mount from
> util-linux 2.12r, and I put up the result for ftp at
> ftp://ftp.win.tue.nl/pub/linux-local/utils/mount/mount-2.12r-ggk.tar.gz

 Hmm.. some distributions and also util-linux-ng already use Ram Pai's
 shared subtrees patch:

 http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=commitdiff;h=389fbea536e4308d9475fa2a89e53e188ce8a0e3

> [By the way, this shared subtree stuff is a bit messy,
> and impossible to support correctly by mount without help
> from the kernel. So far the shared/slave/unbindable status
> of mounts is not visible in /proc/mounts or /proc/$$/mountstats.

 Unfortunately, you're right.

 We need something like /proc/PID/mounts_propagation
 (see 2nd patch in):
 http://www.mail-archive.com/util-linux-ng@vger.kernel.org/msg00136.html

> The above mount makes a feeble attempt to record these flags
> in /etc/mtab, but will fail in any nontrivial situation.]

 I don't think that mtab is a good place for this shared subtree
 stuff. The mtab needs to die.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
