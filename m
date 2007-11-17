Return-Path: <linux-kernel-owner+w=401wt.eu-S1761379AbXKQEYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379AbXKQEYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 23:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbXKQEYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 23:24:13 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:55828 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXKQEYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 23:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=e4wRtDbPC+Pk3kv3FzDkAhvDjBMT0Y2rTF3U5tDCO2K20unF4le33wBr3U+pm1ryGrF8fgB5ahYZVWrnqofREC1l/H8B34SP+06999cmVPrEw4C9yBirpl8Yutp/wwlT7WgtkuMnETrHU/+UDEuD7nyoJUn21/KKifKqqojpvMk=
Message-ID: <473E6CE7.4010606@googlemail.com>
Date: Sat, 17 Nov 2007 05:24:07 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
Subject: bug in scripts/setlocalversion 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've build by 'accident' and stable kernel inside a git repo and noticed an strange bug.

setlocalversion will append a git revision to the kernel even is not an git one.

to reproduce create some dir and cd in there:

git init 
git config user.email "foo@email.com"
git config user.name "blah"

touch a b c
git add *
git commit -a

git rev-parse --verify HEAD 2
7e671bce0cdc4ace727794dc79d5b426551ae5b8

now get any kernel tarball from kernel.org , unpack and build it with make V=1


--($:/work/crazy/bug/linux-2.6.24-rc2)-- LC_ALL=C; ls -d .git
/usr/bin/ls: cannot access .git: No such file or directory

( we are not git )
                                                                                                
...

--($:/work/crazy/bug/linux-2.6.24-rc2)-- make V=1
rm -f include/config/kernel.release
echo 2.6.24-rc2-g7e671bce > include/config/kernel.release <-- buggy

...

Possible fix is to add and check before :                                                                                           

# Check for git and a git repo.
if head=`git rev-parse --verify HEAD 2>/dev/null`; then

which actually is missing the 'git' check ;)

if [ -d ".git" ]; then 
	if head=`git rev-parse --verify HEAD 2>/dev/null`; then
	...
fi


or some git magic command I don't know yet =) 


Regards,

Gabriel 
