Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYA0JJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYA0JJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYA0JJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:09:27 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:35168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYA0JJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Gs2+75mP88VEO4MAj0rOaO687kb9vCCEkkTYkZc+Age4awKDNahJe+bBkPsCE4oMeb4tn6i0MubkMVDnAM0ACTl0wAlF/gCV6xNngt4z25scn2V1RRa0i4AgAqISgtg1dRhS8sqgUdHM8bGxGXtu9+xzlc94VnJMdZYZ7z2Ymw8=
Message-ID: <479C4A28.3020705@gmail.com>
Date: Sun, 27 Jan 2008 14:38:56 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: jkenisto@us.ibm.com, ananth@in.ibm.com,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Non kprobe breakpoints in the kernel might lie inside the .kprobes.text section. Such breakpoints can easily be identified by in_kprobes_functions and can be caught early. These are problematic and a warning should be emitted to discourage them (in any rare case, if they actually occur).

For this, a check can route the trap handling of such breakpoints away from kprobe_handler (which ends up calling even more functions marked as __kprobes) from inside kprobe_exceptions_notify.

All comments/suggestions are welcome.

--
Thanks & Regards,
Abhishek Sagar
