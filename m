Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902Ab0BEV7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:59:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:40878 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933863Ab0BEV7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:59:10 -0500
Message-ID: <4B6C94AC.7000301@suse.cz>
Date: Fri, 05 Feb 2010 22:59:08 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: tags: include headers before source files
References: <Pine.LNX.4.64.1002031704550.6324@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002031704550.6324@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.2.2010 17:25, Guennadi Liakhovetski wrote:
> Currently looking up a structure definition in TAGS / tags takes one to 
> one of multiple "static struct X" definitions in arch sources, which makes 
> it for many structs practically impossible to get to the required header. 
> This patch changes the order of sources being tagged to first scan 
> architecture includes, then the top-level include/ directory, and only 
> then the rest. It also takes into account, that many architectures have 
> more than one include directory, i.e., not only arch/$ARCH/include, but 
> also arch/$ARCH/mach-X/include etc.

Hi Guennadi

This is a cool idea, but there is one issue:


>  # find sources in arch/$1/include
>  find_arch_include_sources()
>  {
> -	find ${tree}arch/$1/include $ignore -name "$2" -print;
> +	include=$(find ${tree}arch/$1/ -name include -type d);
> +	archincludedir+=$include
> +	find $include $ignore -name "$2" -print;

You need to check if $include isn't empty, which it is on i386 or x86_64
(and on other archs where $ARCH != $SRCARCH). If I do a 'make cscope'
after your change, the second find statement crawls the whole filesystem.

Michal

