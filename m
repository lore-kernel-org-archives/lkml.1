Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZICSDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZICSDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZICSDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:03:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZICSDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:03:10 -0400
Date: Thu, 3 Sep 2009 19:58:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org
Subject: Re: binfmt_flat.c && bprm->cred (Was: [PATCH 0/1] exec: do not
	sleep in TASK_TRACED under ->cred_guard_mutex)
Message-ID: <20090903175823.GA28752@redhat.com>
References: <20090903160510.GA23638@redhat.com> <20090903162939.GA24528@redhat.com> <20090903165850.GC5485@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903165850.GC5485@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Cyrill Gorcunov wrote:
>
> [Oleg Nesterov - Thu, Sep 03, 2009 at 06:29:39PM +0200]
> | On 09/03, Oleg Nesterov wrote:
> | >
> | > load_flat_shared_library() does something strange (but hopefully this
> | > patch doesn't break it). I do not understand why does it create the
> | > new bprm. Afaics, it could reuse bprm pointer which comes as an argument
> | > of ->load_binary(), all we need is to temporary change/restore bprm->file
> | > for load_flat_file().
> |
> | IOW, afaics the patch below makes sense. Imho it is a bit ugly binfmt_flat.c
> | plays with prepare_exec_creds().
> |
> | But again, I don't understand this code, and I didn't even try to compile
> | this patch.
> |
> | Oleg.
> |
> ...
> | -static int load_flat_shared_library(int id, struct lib_info *libs)
> | +static int load_flat_shared_library(struct linux_binprm *bprm, int id,
> | +						struct lib_info *libs)
> |  {
> ...
> | +	sprintf(buf, "/lib/lib%d.so", id);
>
> Hi Oleg, perhaps it is a good moment to switch sprintf to snprintf
> as well? buf is only 16 bytes long so we have 4 byte room for number.

Agreed. As you pointed out privately we have MAX_SHARED_LIBS=4, but
still snprintf() is safer.

Oleg.

