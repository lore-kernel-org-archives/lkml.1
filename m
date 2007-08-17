Return-Path: <linux-kernel-owner+w=401wt.eu-S1761863AbXHQRSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761863AbXHQRSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 13:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbXHQRSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 13:18:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbXHQRSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 13:18:43 -0400
To: linux-kernel@vger.kernel.org
Subject: SVr4/SVID/SUS IPC conformance
From: Anton Arapov <aarapov@redhat.com>
X-URL: http://people.redhat.com/aarapov
Date: Fri, 17 Aug 2007 19:18:40 +0200
Message-ID: <h8ps1mm64v.fsf@pepelac.englab.brq.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

* Please, gurus, who cares about standards conformance, do not ignore this message!

  SysV code returns EIDRM for collision of IDs. I sure it should return EINVAL.

  Steps to reproduce: (this for shared memory code, for msg/sem it is the same)
   1. Create then drop 2 shmem segments, then create a third.
   2. Try to shmctl(IPC_STAT) the two now-invalid shm IDs.
   3. Note error codes returned.

   One call gives EINVAL, one gives EIDRM due to collision with the third shmem \
segment.  Should both give EINVAL, this is what I've got on every other Unix I've \
tried it on. 

  IPC code is good, EIDRM is justification of EINVAL. But neither SVr4 nor SVID \
documents EIDRM.   Single Unix Specification mentions EINVAL but not EIDRM as a \
possible failure for shmctl(), so the current kernel behavior is not merely \
self-inconsistent but a flat violation of the spec. 

  Can somebody explain why do we have EIDRM?

Anton.
SUS: http://www.opengroup.org/onlinepubs/007908799/xsh/shmctl.html
-- 
Anton Arapov, <aarapov@redhat.com>
