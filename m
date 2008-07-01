Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYGAWSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYGAWSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758505AbYGAWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:18:13 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55136 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757768AbYGAWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:18:11 -0400
Date: Wed, 2 Jul 2008 00:18:08 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux fatal: cannot describe <sha1>
Message-ID: <20080701221808.GA26272@Chamillionaire.breakpoint.cc>
References: <alpine.LNX.1.10.0807011817230.20393@fbirervta.pbzchgretzou.qr> <20080701200951.GB10677@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080701200951.GB10677@uranus.ravnborg.org>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg | 2008-07-01 22:09:51 [+0200]:

>> Just a note that when you run git-describe, you should probably quiten it.
>> 
>> fatal: cannot describe 'bd7364a0fd5a4a2878fe4a224be1b142a4e6698e'
>> 
>> This happens when tags are not present, which can happen if Linus's tree 
>> is sent upwards again, IOW:
>> 
>>  machine1$  git-clone torvalds/linux-2.6.git
>>  machine1$  git push elsewhere master
>> 
>>  machine2$  git-clone elsewhere:/linux
>>  machine2$  git-describe HEAD
>>  fatal: cannot describe that
>
>Hi Jan.
>
>Any specific reason why you sent it to me?
>Maybe because I do not use git describe at all?
Maybe he was thinking about this (and didn't know that you were moving):

---
scripts: don't desribe if there is nothing to describe

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 scripts/setlocalversion |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 1c1bdaf..83b7512 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -12,7 +12,9 @@ cd "${1:-.}" || usage
 if head=`git rev-parse --verify HEAD 2>/dev/null`; then
 	# Do we have an untagged version?
 	if git name-rev --tags HEAD | grep -E '^HEAD[[:space:]]+(.*~[0-9]*|undefined)$' > /dev/null; then
-	        git describe | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+		if tag=`git describe 2>/dev/null`; then
+			echo $tag | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+		fi
 	fi
 
 	# Are there uncommitted changes?
-- 
1.5.5.4

