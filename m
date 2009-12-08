Return-Path: <linux-kernel-owner+w=401wt.eu-S965376AbZLHBrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376AbZLHBrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbZLHBrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:47:09 -0500
Received: from mail.perches.com ([173.55.12.10]:1089 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965309AbZLHBrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:47:08 -0500
Subject: Re: [PATCH] NTFS: Change string pointers to string constants.
From: Joe Perches <joe@perches.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: John Daiker <daikerjohn@gmail.com>, kernel-janitors@vger.kernel.org,
       aia21@cantab.net, linux-ntfs-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <C1806924-DE57-4FBA-A67C-85C618FE6639@cam.ac.uk>
References: <1259808806-27279-1-git-send-email-daikerjohn@gmail.com>
	 <C1806924-DE57-4FBA-A67C-85C618FE6639@cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 17:47:13 -0800
Message-ID: <1260236833.3215.237.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 00:57 +0000, Anton Altaparmakov wrote:
> Can you please explain the rational for making this change?

Perhaps it's not worth much, but it saves a pointer reference.

$ cat pointer.c
#include <string.h>
#include <stdio.h>

int main (int argc, char** argv)
{
	static const char *foo = "abcdefg";
	printf("%s\n", foo);
	return 0;
}

$ gcc -c pointer.c
$ size pointer.o
   text	   data	    bss	    dec	    hex	filename
     37	      4	      0	     41	     29	pointer.o

$ cat reference.c
#include <string.h>
#include <stdio.h>

int main (int argc, char** argv)
{
static const char foo[] = "abcdefg";
printf("%s\n", foo);
return 0;
}

$ gcc -c reference.c
$ size reference.o
   text    data     bss     dec     hex filename
     36       0       0      36      24 reference.o



