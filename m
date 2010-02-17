Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0BQNFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:05:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:34746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab0BQNFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:05:12 -0500
Message-ID: <4B7BE984.60107@suse.cz>
Date: Wed, 17 Feb 2010 14:05:08 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2] tags: include headers before source files
References: <Pine.LNX.4.64.1002031704550.6324@axis700.grange> <4B6C94AC.7000301@suse.cz> <Pine.LNX.4.64.1002080022290.15951@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002080022290.15951@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.2.2010 00:25, Guennadi Liakhovetski wrote:
> Currently looking up a structure definition in TAGS / tags takes one to
> one of multiple "static struct X" definitions in arch sources, which makes
> it for many structs practically impossible to get to the required header.
> This patch changes the order of sources being tagged to first scan
> architecture includes, then the top-level include/ directory, and only
> then the rest. It also takes into account, that many architectures have
> more than one include directory, i.e., not only arch/$ARCH/include, but
> also arch/$ARCH/mach-X/include etc.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
> ---
> 
> v1 -> v2:
> 
> 1. check if $include variable is not empty - thanks, Michal, for testing

Thanks, applied with the following change added (+= is a bash extension):

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 6f0985d..c122041 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -33,7 +33,7 @@ fi
 find_arch_sources()
 {
        for i in $archincludedir; do
-               prune+="-wholename $i -prune -o "
+               prune="$prune -wholename $i -prune -o"
        done
        find ${tree}arch/$1 $ignore $prune -name "$2" -print;
 }
@@ -43,7 +43,7 @@ find_arch_include_sources()
 {
        include=$(find ${tree}arch/$1/ -name include -type d);
        if [ -n "$include" ]; then
-               archincludedir+="$include "
+               archincludedir="$archincludedir $include"
                find $include $ignore -name "$2" -print;
        fi
 }

Michal
