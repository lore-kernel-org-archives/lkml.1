Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbYB1Wgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbYB1Wgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYB1Wg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:36:28 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:41173 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbYB1Wg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:36:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nbDvZiGW2bgF4Kt43sGDWcTOQZ17effPhMdQ14cTSBXHL+2yI6Lt/y2i1A5IIevnCPsrEXyh56nb6mJX0CFzyBgwJQeVaLqwGmBMQxxFH9fL5QhAx6Zlm9plWXmO1ea04y9HLmQWUpOA3pW+MdZwZ24K0j/sXA+lKabtOzQjBIo=
Message-ID: <9a8748490802281436h350bccafy88bb059d63fe3b74@mail.gmail.com>
Date: Thu, 28 Feb 2008 23:36:24 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: + markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200802280334.m1S3YbWM013644@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802280334.m1S3YbWM013644@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/2008, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
>  The patch titled
>      markers-dont-risk-null-deref-in-marker-checkpatch-fixes
>  has been added to the -mm tree.  Its filename is
>      markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
>
<snip>
>  Subject: markers-dont-risk-null-deref-in-marker-checkpatch-fixes
>  From: Andrew Morton <akpm@linux-foundation.org>
>

Andrew,  I very much do not agree with you and/or checkpatch here :

>  WARNING: braces {} are not necessary for single statement blocks
>  #34: FILE: kernel/marker.c:715:
>  +       if (!entry) {
>  +               goto end;
>  +       }
>
>  total: 0 errors, 1 warnings, 29 lines checked
>
>  ./patches/markers-dont-risk-null-deref-in-marker.patch has style problems, please review.  If any of these errors
>  are false positives report them to the maintainer, see
>  CHECKPATCH in MAINTAINERS.
>
>  Please run checkpatch prior to sending patches
>
>  Cc: Jesper Juhl <jesper.juhl@gmail.com>
>  Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  ---
>
>   kernel/marker.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
>  diff -puN kernel/marker.c~markers-dont-risk-null-deref-in-marker-checkpatch-fixes kernel/marker.c
>  --- a/kernel/marker.c~markers-dont-risk-null-deref-in-marker-checkpatch-fixes
>  +++ a/kernel/marker.c
>  @@ -702,9 +702,8 @@ int marker_probe_unregister(const char *
>
>         mutex_lock(&markers_mutex);
>         entry = get_marker(name);
>  -       if (!entry) {
>  +       if (!entry)
>                 goto end;
>  -       }
>         if (entry->rcu_pending)
>                 rcu_barrier();
>         old = marker_entry_remove_probe(entry, probe, probe_private);
>  @@ -712,9 +711,8 @@ int marker_probe_unregister(const char *
>         marker_update_probes();         /* may update entry */
>         mutex_lock(&markers_mutex);
>         entry = get_marker(name);
>  -       if (!entry) {
>  +       if (!entry)
>                 goto end;
>  -       }
>         entry->oldptr = old;
>         entry->rcu_pending = 1;
>         /* write rcu_pending before calling the RCU callback */

While it is entirely true that the compiler has no need for the extra
{} they are very nice for human readers/editors of the code - and if
what's inside happens to be a macro, also potentially safer.

I left them in very much on purpose.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
