Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab0BCQHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:07:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:38923 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab0BCQHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:07:10 -0500
Date: Wed, 3 Feb 2010 17:07:09 +0100
From: Michal Marek <mmarek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Anibal Monsalve Salazar <anibal@debian.org>
Subject: Re: [PATCH 4/4] kconfig: Add LSMOD=file to override the lsmod for
 localmodconfig
Message-ID: <20100203160708.GA9035@sepie.suse.cz>
References: <20100203154605.461025238@goodmis.org>
 <20100203154906.499020585@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203154906.499020585@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:46:09AM -0500, Steven Rostedt wrote:
> +# if no path is given, then use src directory to find file
> +ifdef LSMOD
> +LSMOD_F = $(shell if [ `basename $(LSMOD)` == $(LSMOD) ]; then \
> +		echo $(objtree)/$(LSMOD);			\
> +	else							\
> +		echo $(LSMOD);					\
> +	fi)
> +endif

You can do this within make like:

ifdef LSMOD
LSMOD_F := $(LSMOD)
ifeq ($(findstring /,$(LSMOD)),)
  LSMOD_F := $(objtree)/$(LSMOD)
endif
endif

Michal
