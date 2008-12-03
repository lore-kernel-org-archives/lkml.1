Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYLCHFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYLCHFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYLCHEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:04:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:59240 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYLCHEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=o2auLB1QPCjw5or+PiBi29gD98QDCD9wzElwzpzjmRQPTq8CL/5jX1TcFz+J8nzRpn
         VTlV0KUONBHSVHmcidCCTZpR+gD4gpIwdQyKeXUr2JIAA2HYmeLMPfyCVX1R2uu3II0O
         cC233JW0SCKnur/azwt9XaKdg4Ut580ElMRUU=
Message-ID: <cb94e63d0812022304x49dfe519if4f8a8572a396672@mail.gmail.com>
Date: Wed, 3 Dec 2008 09:04:49 +0200
From: "wassim dagash" <wassim.dagash@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: KSWAPD Algorithm - 100% CPU
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
Description:
I countered a weird problem with kswapd:
it runs in some infinite loop trying to swap until order 10 of zone
highmem is OK, While zone higmem (as I understand) has nothing to do
with contiguous memory (cause there is no 1-1 mapping) which means
kswapd will continue to try to balance order 10 of zone highmem
forever (or until someone release a very large chunk of highmem).
Can anyone please explain me the algorithm of kswapd and why it tries
to balance order 10 of zone higmem ?

Details:
I build an instrumented kernel with debug messages in
"zone_watermark_ok" function, and from the code and debug messages I
see that "zone_watermark_ok" returns 0 when kswapd invokes it (through
balance_pgdat) in order to decide if zone highmem is balanced or not,
which lead in some configurations to infinite loop of kswapd ( if no
large chunks of highmem released) . I added a condition to
"balance_pgdat" so it doesn't try to balance order higher than 1 in
zone highmem and this conditon solved the problem, what are the risks
with such solution? isn't it a bug that kswapd is looking for
continuous memory in zone highmem ( as I understand there is no 1-1
mapping in zone highmem which is meaningless in kswapd)?

NOTE: I WANT TO BE CC'ed TO THE THREAD!

Regards,
