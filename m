Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0BORmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 12:42:45 -0500
Received: from mail-bw0-f213.google.com ([209.85.218.213]:64133 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0BORmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NCNn01oc8rM4ixQSIJ1ZkLeSobPkPbBUOFGRN5p9reHzElr0wYYutm6Flpot0ulrhI
         ivChtVfFSpa40CSIakYeck3mNS/6AcaYQLwrSrPNhkXjTdeAj4SzME/s/jOehSEcSsi1
         gBQBXtQjvcOISjJIebnVI0RIJqBVuqMRnxjDA=
Subject: Re: [patch/rfc] Make poll/select report error (POLLNVAL and EBADF)
 for unsupported files
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stephane.thiell@cea.fr
In-Reply-To: <alpine.DEB.2.00.1002141403240.18795@makko.or.mcafeemobile.com>
References: <alpine.DEB.2.00.1002141403240.18795@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 18:42:39 +0100
Message-ID: <1266255759.8262.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 février 2010 à 14:27 -0800, Davide Libenzi a écrit :
> Currently poll and select consider a non poll-supported file as one with 
> full event mask set, instead of reporting proper error to the caller.
> This behavior can fool the caller of proper functionality being returned, 
> while instead no valid event was processed/read from the device.
> This came out linked to this bug report:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=15272
> 
> IMHO, it'd be more adequate to report proper error code, for files that do 
> not support f_op->poll(), but then I am also not sure how much breakage 
> can this bring to existing (already broken "in just the right way") 
> applications.
> Untested, discussion-only, patch.
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide

Hmm, according to POSIX :

	The poll() function shall support regular files, terminal and
pseudo-terminal devices, FIFOs, pipes, sockets ...

	Regular files shall always poll TRUE for reading and writing.


So unless I missed something, this patch could break some conformant
applications.

In particular, if an application is polling() on stdin (usually a tty),
and other 'files', what's happening if we do :

cat replay_file | application

Either it wont read stdin, or application exits without reading its
input.



