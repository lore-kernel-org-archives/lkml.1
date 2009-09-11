Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZIKUqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZIKUqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZIKUqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:46:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001AbZIKUql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:46:41 -0400
Date: Fri, 11 Sep 2009 13:45:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: torvalds@linux-foundation.org, jakub@redhat.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 1/2] UNREACHABLE() macro
Message-Id: <20090911134528.cd1782d9.akpm@linux-foundation.org>
In-Reply-To: <20090910020031.87DC68BF6E@magilla.sf.frob.com>
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
	<20090910020031.87DC68BF6E@magilla.sf.frob.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Sep 2009 19:00:31 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> +/*
> + * __builtin_unreachable is available in GCC 4.5+ and
> + * also in Fedora/Red Hat GCC 4.4.1-10+.
> + */
> +#if (__GNUC_MINOR__ > 4					\
> +     || (__GNUC_MINOR__ == 4				\
> +	 && defined __GNUC_RH_RELEASE__			\
> +	 && (__GNUC_PATCHLEVEL__ > 1			\
> +	     || (__GNUC_PATCHLEVEL__ == 1		\
> +		 && __GNUC_RH_RELEASE__ >= 10))))
> +#define UNREACHABLE()		__builtin_unreachable()
> +#endif

That's a bit of a mouthful.  Did you consider a runtime probe with
scripts/Kbuild.include's try-run, cc-option, etc?  
