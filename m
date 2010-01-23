Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779Ab0AWXHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0AWXHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 18:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406Ab0AWXHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 18:07:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40047 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0AWXHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 18:07:40 -0500
Date: Sat, 23 Jan 2010 23:07:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [RFC PATCH 1/2] Fix 1 untangling ima mess, part 2 with counters
Message-ID: <20100123230735.GW19799@ZenIV.linux.org.uk>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com> <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 03:35:40PM -0500, Mimi Zohar wrote:
> The "Untangling ima mess, part 2 with counters" patch messed
> up the counters.  Based on conversations with Al Viro, this patch
> streamlines ima_path_check() by removing the counter maintaince.
> The counters are now updated independently, from measuring the file,
> in __dentry_open() and alloc_file() by calling ima_counts_get().
> ima_path_check() is called from nfsd and do_filp_open().
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  fs/namei.c                        |    4 +-
>  include/linux/ima.h               |    4 +-
>  security/integrity/ima/ima_main.c |  234 ++++++++++++++-----------------------

Um...
	a) where's the nfsd part?
	b) will that work if we open file with O_WRONLY?

nfsd side of things is non-trivial.  Note that you have that thing called
an awful lot; nfsd_permission() is called by fh_verify().  For which
operations do you really want it to happen?  Should it just migrate to
nfsd_open()?
