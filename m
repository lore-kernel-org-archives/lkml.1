Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbYBHDrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbYBHDrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 22:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbYBHDrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 22:47:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832AbYBHDri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 22:47:38 -0500
Date: Thu, 7 Feb 2008 19:47:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] sysctl: allow embedded targets to disable
 sysctl_check.c
Message-Id: <20080207194735.35d87346.akpm@linux-foundation.org>
In-Reply-To: <200802071438.58497.hs4233@mail.mn-solutions.de>
References: <200802071438.58497.hs4233@mail.mn-solutions.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 14:38:58 +0100 Holger Schurig <hs4233@mail.mn-solutions.de> wrote:

> Disable sysctl_check.c for embedded targets. This saves about about 11 kB
> in .text and another 11 kB in .data on a PXA255 embedded platform.
> 

Nice improvement.  But iirc sysctl_check was overtly a temporary thing.
Eric, was that the intention?

> 
> --- linux.orig/init/Kconfig
> +++ linux/init/Kconfig
> @@ -475,6 +475,17 @@
>  
>  	  If unsure say Y here.
>  
> +config SYSCTL_SYSCALL_CHECK
> +	bool "Sysctl checks" if EMBEDDED
> +	depends on SYSCTL_SYSCALL
> +	default y
> +	---help---
> +	  sys_sysctl uses binary paths that have been found challenging
> +	  to properly maintain and use. This enables checks that help
> +	  you to keep things correct.
> +
> +	  If unsure say Y here.
> +

