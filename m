Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbZFBJkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbZFBJkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZFBJkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:40:47 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:51926 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZFBJkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=nObxAd96/4Z4Dy4yyyFz6FNX0A80R0Vth6lzTbmHrDpXc64jp//CQ369kmBwpfiuTH
         PRhNSLnqfu8bRYeD5pIl7NCbyFM4GoHggZl9U3QWSsfdxuR1akVNv/roYpxcRWThlqXO
         Z6Qibq7XwBq+kZG1WGGGks7NphRdAXxJVnbYo=
Date: Tue, 2 Jun 2009 11:41:06 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: linux-kernel@vger.kernel.org
Subject: smatch 1.53 released
Message-ID: <alpine.DEB.2.00.0906021141010.19390@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch is a source code checker for C.  Right now the focus is on checking 
for kernel bugs.

Here is are the instructions for installing and using:
    git clone git://repo.or.cz/smatch.git
    cd smatch
    make
    cd /usr/src/linux
    make C=1 CHECK=/path/to/smatch modules bzImage | tee warns.txt 
    egrep '(warn|error):' warns.txt

Some weeks ago I pushed a bad commit.  I haven't had internet access to 
fix it until now.  Sorry about that.  It's fixed now.

Smatch v1.53 improves handling of compound implications.  So if you have 
code like this:
        aaa = 0;
        if (y)
                aaa = 1;
        if (x)
                aaa = 2;
        if (x && y)
                __smatch_print_value("aaa");  // <-- prints aaa == 2
        else
                __smatch_print_value("aaa");  // <-- prints aaa == 0-2

This version also adds implications for switch statements.
        if (!a && x != 42)
                return;
        switch(x) {
        case 1:
                a->member = 1;  // <--  It's ok to dereference 'a' here.
        case 42:
                a->member = 1;  // <-- smatch prints an error here.

regards,
dan carpenter
