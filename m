Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760135AbYLQJUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYLQJUO (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbYLQJT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:19:28 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:25284 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbYLQJTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:19:25 -0500
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: PROC macro to annotate functions in assembly files
Date: Wed, 17 Dec 2008 10:17:53 +0100
Message-Id: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 17 Dec 2008 10:18:32 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.45; VDF: 7.1.0.243; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch introduces the PROC macro in the generic
header file include/linux/linkage.h to annotate functions
in assembly files. This is a first step to fully annotate
functions (procedures) in .S-files. The PROC macro
complements the already existing and being used ENDPROC
macro. The generic implementation of PROC is exactly the
same as ENTRY.

The goal is to annotate functions, at least those called
from C code, with PROC at the beginning and ENDPROC at the
end. This is for the benefit of debugging and tracing.

The second patch introduces a framework to check for nesting
problems and missing annotations by overriding ENTRY/END
and PROC/ENDPROC in x86-specific code. It should not be
applied at this time, because it will just cause the build
to fail due to existing annotation problems. I intend to
fix the annotations for the x86 assembly files in the
comming months and resubmit this second patch if this
work is comming to an end.

The first patch touches generic code, but I think it is
trivial enough that it can be introduced via the x86 tree.

Greetings,
	Alexander
