Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZGAUgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZGAUgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZGAUgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:36:41 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47153 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZGAUgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ugk9bW3Ne1Ysm3eEMrmt67qcxNd1xHurZJjPO6eUIrMY07zAD18yRSiAGGqhyHatWn
         /WZhhz0+pBec+CFAFLjBfwcaAEfzER7gzWz/vscYx3xE44In1hdbtULQNAY1K/96ycL/
         D7M4ykC3LKlS2j7IaKWndR5BHu72vYQkSwwH8=
MIME-Version: 1.0
In-Reply-To: <5Hhc7UkUKEO.A.5zE.DjASKB@chimera>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.5zE.DjASKB@chimera>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Wed, 1 Jul 2009 21:36:18 +0100
Message-ID: <a5d9929e0907011336g31599a29hca3c204f1b53b775@mail.gmail.com>
Subject: Re: [Bug #13660] Crashes during boot on 2.6.30 / 2.6.31-rc, random 
	programs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No formal patch has been sent yet, that i am aware of. I have made
some changes following suggestion by Americo Wang advise, to the
following:

(patch by Ingo)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 699a2ac..031f4c6 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -65,7 +65,7 @@ enum {
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
  */
-#define MAX_STACK_TRACE_ENTRIES	262144UL
+#define MAX_STACK_TRACE_ENTRIES	1048576UL

 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];

and afterwards, a new bug popped up, solved by changing

include/linux/sched.h

# define MAX_LOCK_DEPTH 48UL

to

# define MAX_LOCK_DEPTH 96UL


I have now found a third limit bug, related to MAX_LOCKDEP_CHAINS,
which was hidden so far, which im trying to raise and replicate. This
is being discussed in detail in another message exchange on the lkml,
between me and Americo.

Thank you very much for your time,
Joao Correia
Centro de Informatica
Universidade da Beira Interior
Portugal



On Mon, Jun 29, 2009 at 1:31 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13660
> Subject         : Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
> Submitter       : Joao Correia <joaomiguelcorreia@gmail.com>
> Date            : 2009-06-27 16:07 (2 days old)
> References      : http://lkml.org/lkml/2009/6/27/95
>
>
>
