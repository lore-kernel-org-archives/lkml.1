Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZAHFku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZAHFku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 00:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZAHFkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 00:40:40 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:35252 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZAHFkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 00:40:39 -0500
Date: Thu, 8 Jan 2009 06:42:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kbuild vs ccache
Message-ID: <20090108054215.GA11628@uranus.ravnborg.org>
References: <20090108040336.28B10FC3E0@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108040336.28B10FC3E0@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 08:03:36PM -0800, Roland McGrath wrote:
> 
> make clean; ccache -s > before-`git describe`; make -j9; ccache -s > after-`git describe`; diff -u {before,after}-`git describe`
> 
> v2.6.28:
> 
> -cache hit                         737661
> -cache miss                        979624
> -called for link                    78268
> +cache hit                         738093		= +432
> +cache miss                        980524		= +900
> +called for link                    78289		= +21
>  multiple source files                373
>  compile failed                      5679
>  preprocessor error                  1594
> -not a C/C++ file                   44512
> +not a C/C++ file                   44549		= +37
> 
> 1332	cacheable
> 58	uncacheable
> 
> 
> v2.6.28-7485-g9e42d0c:
> 
> -cache hit                         738096		= +9
> +cache hit                         738105
>  cache miss                        980524		= +0
> -called for link                    78293
> +called for link                    79659		= +1366
>  multiple source files                373
>  compile failed                      5679
>  preprocessor error                  1594
> -not a C/C++ file                   44549		= +1384
> +not a C/C++ file                   45933
> 
> 9	cacheable
> 2750	uncacheable
> 
> 
> What changed?

Before we did a straight .c -> .o 
Now we do .c -> .s -> .o to mark __crc_ symbols static so we can
kill them when stripping modules.

It is already being discussed in another thread.
See "[REGRESSION] Recent change to kernel spikes out ccache/distcc"

	Sam
