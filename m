Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYIDPTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYIDPTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYIDPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:19:05 -0400
Received: from www.tglx.de ([62.245.132.106]:56975 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbYIDPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:19:04 -0400
Message-Id: <20080904150339.896115280@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 15:18:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>
Subject: [RFC patch 0/4] TSC calibration improvements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series addresses following:

     - reduce the calibration time to a useful value
     - make decision smarter, when a reference (HPET/PMTIMER) is around

The first patches are cleanups to prepare for the smarter loop
handling.

The main change is to reduce the PIT delay value to 10ms, which gives
reasonable results on very slow machines as well. To avoid looping
several times when the machine has a working reference counter
(HPET/pmtimer), we compare the results of the PIT and the reference and
break out of the loop when both match inside of a 10% window.

For virtualized environments the PIT calibration fails often and the
reference calibration is not reproducible with 10ms. To address this
we check whether the PIT failed two times in a row and make the PIT
loop longer (50ms) for the last try to get a better result for the
reference.

Most of the machines I tested break out of the loop after the first
try with a stable reproducible result.

Thanks,

	tglx
-- 

