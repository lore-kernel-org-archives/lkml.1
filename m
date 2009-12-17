Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZLQF3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZLQF3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZLQF3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:29:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZLQF3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:29:05 -0500
Message-ID: <4B29BFE8.1000502@zytor.com>
Date: Wed, 16 Dec 2009 21:21:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>, Michal Marek <mmarek@suse.cz>
CC: Masami Hiramatsu <mhiramat@redhat.com>, Andrew Isaacson <adi@vmware.com>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>	<adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com>	<ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com>
In-Reply-To: <aday6l25gnm.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 09:11 PM, Roland Dreier wrote:
> 
>  > As Al Viro said, if we run awk with LC_ALL=C, then the characters will be
>  > sorted as ASCII. So, your patch is OK if you can add LC_ALL=C just before
>  > $(AWK). (I'm not so sure whether Makefile can accept it...)
> 

I would strongly prefer the following solution as it solves this entire
class of problems globally, although I'd really want Michal's ACK for it:

diff --git a/Makefile b/Makefile
index 33d4732..7fefc13 100644
--- a/Makefile
+++ b/Makefile
@@ -302,6 +302,10 @@ MAKEFLAGS += --include-dir=$(srctree)
 $(srctree)/scripts/Kbuild.include: ;
 include $(srctree)/scripts/Kbuild.include

+# Avoid funny character set dependencies
+LC_ALL=C
+export LC_ALL
+
 # Make variables (CC, etc...)

 AS		= $(CROSS_COMPILE)as


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

