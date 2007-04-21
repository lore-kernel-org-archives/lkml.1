Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXDUHUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXDUHUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbXDUHUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:20:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933041AbXDUHUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:20:50 -0400
Date: Sat, 21 Apr 2007 00:20:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] [KERNEL-DOC] kill warnings when building mandocs
Message-Id: <20070421002045.36a663ba.akpm@linux-foundation.org>
In-Reply-To: <20070419071931.GA4778@gollum.tnic>
References: <20070413091422.GA15426@zmei.tnic>
	<20070413092943.GA16491@zmei.tnic>
	<20070418101654.7c7906c1.randy.dunlap@oracle.com>
	<20070419063019.GB3974@gollum.tnic>
	<20070419071931.GA4778@gollum.tnic>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 09:19:32 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:

> +# get kernel version
> +sub get_kernel_version() {
> +    my $version;
> +    open (FILE, $ENV{"SRCTREE"}."Makefile") || die "Can't open main kernel Makefile: $!";
> +
> +    EOF: while (my $line = <FILE>)
> +    {
> +	if ($line =~ /VERSION\s+=\s+(\d+)/) {
> +	     $version .= $1;
> +	     next;
> +	}
> +	if ($line =~ /PATCHLEVEL\s+=\s+(\d+)/) {
> +	     $version .= ".$1";
> +	     next;
> +	}
> +	if ($line =~ /SUBLEVEL\s+=\s+(\d+)/) {
> +	     $version .= ".$1";
> +	     next;
> +	}
> +	if ($line =~ /EXTRAVERSION\s+=\s+(.*)$/) {
> +	     $version .= $1;
> +	     last EOF;
> +	}
> +    }
> +    return $version;
> +}

we already did this in the top-level Makefile.  It's in $(KERNELVERSION)
and is printed by `make kernelversion'.

Cannot we use that info somehow?
