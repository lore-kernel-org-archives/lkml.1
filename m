Return-Path: <linux-kernel-owner+w=401wt.eu-S1762468AbYETRDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762468AbYETRDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYETRDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:03:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:41835 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbYETRDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=eJj2JRXLuKBh4I0xUAwQBXdqH+Bkg1XuHm6aNOQyDy5puw5OpMLUnxYUtI0LKEySVM+hEsyiilOVpgyQHSjJjqdVp6w6mOqGPiRdRuspgo/R/H0/9h6ZJlXtrdj/ASFrWk4bQgjh8lcLYeXnqB3mh02E8/ixalncgk2AUNhFqq8=
Date: Tue, 20 May 2008 21:03:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Michael A. Halcrow" <mhalcrow@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [Q] eCryptFS race window?
Message-ID: <20080520170321.GC6926@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

it seems there is a few potential race window in eCryptFS which I was trying
to fix but it requires more deeper eCrypFS knowledge that have (at least only
by understanding eCryptFS in big picture it is possible to fix this problem
by elegant path). So what is the problem - the procedures

	ecryptfs_miscdev_poll
	ecryptfs_miscdev_read

does take ecryptfs_daemon_hash_mux mutex and then daemon->mux _but_ releases
them not in exactly backward order as it should. My patches (not in mainline
but you saw them) was screwed up 'cause mutex_is_locked could release mutex
acquired by another process and that is wrong. But I've a hope that I'm simply
*wrong* about this possible races ;) Take a look please.

		- Cyrill -
