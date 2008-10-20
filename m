Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYJTMrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYJTMrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYJTMr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:47:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbYJTMr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:47:27 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: truncate blocks outside i_size after generic_file_direct_write error
References: <1224424981-5144-1-git-send-email-dmonakhov@openvz.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 20 Oct 2008 08:47:22 -0400
In-Reply-To: <1224424981-5144-1-git-send-email-dmonakhov@openvz.org> (Dmitri
	Monakhov's message of "Sun, 19 Oct 2008 18:03:00 +0400")
Message-ID: <x498wsj302t.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Monakhov <dmonakhov@openvz.org> writes:

> We need to remove block that was allocated in generic_file_direct_write()
> if we fail. We have to do it *regardless* to blocksize. At least ext2,
> ext3 and reiserfs interpret (i_size < biggest block) condition as error.
> Fsck will complain about wrong i_size. Then fsck will fix the error
> by changing i_size according to the biggest block. This is bad because
> this blocks contain gurbage from previous write attempt. And result in
> data corruption.
>
> In order to call vmtruncate() we have to hold host->i_mutex. This is true
> for generic_file_aio_write(). In fact occasionally it is also true for all
> generic_file_aio_write_nolock() callers except blockdev. But this situation
> may change someday. This patch fix only generic_write_aio_write() case.
> BTW: update generic_file_direct_write's comment with currently outdated.

Do you have a test case for this, by any chance?

Cheers,

Jeff
