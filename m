Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZA3N4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZA3N4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZA3N4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:56:40 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40141 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZA3N4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:56:39 -0500
Date: Fri, 30 Jan 2009 14:56:37 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
In-Reply-To: <1233303396.17301.30.camel@localhost>
Message-ID: <alpine.LSU.2.00.0901301453190.29805@fbirervta.pbzchgretzou.qr>
References: <1233294584.28741.2.camel@localhost>  <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>  <1233297635.17301.11.camel@localhost>  <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>  <1233302349.17301.27.camel@localhost>
 <1233303396.17301.30.camel@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-01-30 09:16, Nathanael Hoyle wrote:
><snipped old version, because of a fixed goof, and this has better
>formatting for mail client>
>
>extern char **environ;
>[...]
>  if(argc==2) {
>    if(execve(argv[1], NULL, environ) == -1) {
>      perror("Failed to execve target!");
>    }
>  } else {
>    if(execve(argv[1], argv+1, environ) == -1) {
>      perror("Failed to execve target!");
>    }
>  }

Are you sure your first execve even works? I would have used

   if (execvp(argv[1], &argv[1]) < 0)
	...

just so (a) I do not have to deal with the ugly 'extern char **environ'
[such should have been in a libc header imho] or use
int main(int argc, char **argv, char **envp); (b) execvp so that
it looks through $PATH, just as /bin/su (resp. the shell it starts) would do.
