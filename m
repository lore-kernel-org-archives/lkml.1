Return-Path: <linux-kernel-owner+w=401wt.eu-S965230AbXFFVkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965230AbXFFVkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936017AbXFFVkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:40:22 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58102 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935914AbXFFVkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:40:21 -0400
Subject: Re: [RFC] [Patch 1/4] statistics: no include hell for users
From: Dave Hansen <hansendc@us.ibm.com>
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jbaron@redhat.com,
       rostedt@goodmis.org, billh@gnuppy.monkey.org, mingo@elte.hu,
       linux-s390@vger.kernel.org
In-Reply-To: <1181165609.7133.20.camel@dix>
References: <1181165609.7133.20.camel@dix>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 14:39:47 -0700
Message-Id: <1181165987.22388.81.camel@spirit.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 23:33 +0200, Martin Peschke wrote:
> 
>  struct statistic_interface {
>  /* private: */
>         struct list_head         list;
> -       struct dentry           *debugfs_dir;
> -       struct dentry           *data_file;
> -       struct dentry           *def_file;
> +       void                    *debugfs_dir;
> +       void                    *data_file;
> +       void                    *def_file; 

If you don't actually dereference the pointer, you should just be able
to declare:

	struct dentry;

and be done with it, right?  You don't _need_ the includes to have just
pointers.

-- Dave

