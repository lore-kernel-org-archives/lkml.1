Return-Path: <linux-kernel-owner+w=401wt.eu-S1762541AbZEHUpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541AbZEHUpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZEHUpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:45:39 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58058 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbZEHUpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:45:39 -0400
Date: Fri, 8 May 2009 22:47:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/14] kbuild: allow compressors (gzip, bzip2, lzma) to take multiple inputs
Message-ID: <20090508204747.GA18041@uranus.ravnborg.org>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-6-git-send-email-hpa@linux.intel.com> <20090508074234.GD12808@uranus.ravnborg.org> <4A0493B0.3090204@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0493B0.3090204@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 01:18:56PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >>diff --git a/scripts/bin_size b/scripts/bin_size
> >>index 43e1b36..55f2161 100644
> >>--- a/scripts/bin_size
> >>+++ b/scripts/bin_size
> >>@@ -1,10 +1,14 @@
> >> #!/bin/sh
> >> 
> >> if [ $# = 0 ] ; then
> >>-   echo Usage: $0 file
> >>+   echo Usage: $0 file...
> >> fi
> >> 
> >>-size_dec=`stat -c "%s" $1`
> >>+size_dec=0
> >>+for file; do
> >>+  fsize=`stat -c "%s" $file`
> >>+  size_dec=`expr $size_dec + $fsize`
> >>+done
> >> size_hex_echo_string=`printf "%08x" $size_dec |
> >>      sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'`
> >> /bin/echo -ne $size_hex_echo_string
> >
> >But I would rather have had this inside makefile.lib...
> >
> 
> It's messy enough as a shell script... it seems like baking it into 
> Makefile syntax would make it even worse.

I did a quick attempt to integrate it in the Makefile - not pretty.
So I dropped that idea.

It is mainly that we should not fill up scripts/ with small
undocumented scripts.

Could you add something like this in the top of the file:

# Find the sum of the size of all files specified and
# output the size as an escaped hex string.
#
# Sample:
# $ ls -l foo
# $ -rw-rw-r-- 1 xxx xxx 146 May  8 22:28 foo
# $ bin_size foo
# $ \\x92\\x00\\x00\\x00
# 146 equals 92 hex

	Sam
