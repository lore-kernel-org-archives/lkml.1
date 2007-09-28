Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbXI1Mzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbXI1Mzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 08:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXI1Mze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 08:55:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:65340 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbXI1Mze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 08:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nk518aFySy+IYD7SZRMyz0dxPT9h8gVgNkqYmWAK+bE3+aWI1eSV3TRy+ZI3uFrzHc7cOAkUmAjz0Rv8ecXve2FPHLy57t57wZJyYmtlcAIFMFHnqwYZh9FeYovKVw09WuL+qxM0lBwz4IvnFeFxB/zvhqIAnB2CZgb0ZFOYHwk=
Message-ID: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
Date: Fri, 28 Sep 2007 14:55:30 +0200
From: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Out of memory management in embedded systems
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applications with dynamic input and dynamic memory usage have some
issues with the current overcommitting kernel. A high memory usage
situation eventually results in that a process is killed by the OOM
killer. This is especially evident in swapless embedded systems with
limited memory and no swap available.

Some kind of notification to the application that the available memory
is scarce and let the application free up some memory (e.g., by
flushing caches), could be used to improve the situation and avoid the
OOM killer. I am currently not aware of any general solution to this
problem, but I have found some approaches that might (or might not)
work:

o Turn off overcommit. Results in a waste of memory.

o Nokia uses a lowmem security module to signal on predetermined
thresholds. Currently available in the -omap tree. But this requires
manual tuning of the thresholds.
http://www.linuxjournal.com/article/8502

o Using madvise() with MADV_FREE to get the kernel to free mmaped
memory, typically application caches, when the kernel needs the
memory.

o A OOM handler that the application registers with the kernel, and
that the kernel executes before the OOM-killer steps in.

Does it exist any other solutions to this problem?

Daniel
