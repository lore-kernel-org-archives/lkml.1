Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYGEM66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYGEM66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 08:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYGEM6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 08:58:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44544 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYGEM6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 08:58:49 -0400
Date: Sat, 5 Jul 2008 14:58:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux fatal: cannot describe <sha1>
In-Reply-To: <20080701221808.GA26272@Chamillionaire.breakpoint.cc>
Message-ID: <alpine.LNX.1.10.0807051454470.28765@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807011817230.20393@fbirervta.pbzchgretzou.qr> <20080701200951.GB10677@uranus.ravnborg.org> <20080701221808.GA26272@Chamillionaire.breakpoint.cc>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2008-07-02 00:18, Sebastian Siewior wrote:
>* Sam Ravnborg | 2008-07-01 22:09:51 [+0200]:
>
>>> Just a note that when you run git-describe, you should probably quiten it.
>>> 
>>> fatal: cannot describe 'bd7364a0fd5a4a2878fe4a224be1b142a4e6698e'
>>> 
>>
>>Hi Jan.
>>
>>Any specific reason why you sent it to me?

You are the buildsystem maintainer :)

>Maybe he was thinking about this (and didn't know that you were moving):

I only took note of that briefly. Should there have been someone
else to send it to?

>---
>scripts: don't desribe if there is nothing to describe
>diff --git a/scripts/setlocalversion b/scripts/setlocalversion
>index 1c1bdaf..83b7512 100755
>--- a/scripts/setlocalversion
>+++ b/scripts/setlocalversion
>@@ -12,7 +12,9 @@ cd "${1:-.}" || usage
> if head=`git rev-parse --verify HEAD 2>/dev/null`; then
> 	# Do we have an untagged version?
> 	if git name-rev --tags HEAD | grep -E '^HEAD[[:space:]]+(.*~[0-9]*|undefined)$' > /dev/null; then
>-	        git describe | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
>+		if tag=`git describe 2>/dev/null`; then
>+			echo $tag | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
>+		fi
> 	fi
> 
> 	# Are there uncommitted changes?

looks ok i'd say.
