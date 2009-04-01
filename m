Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZDAFbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZDAFbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZDAFbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:31:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbZDAFbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:31:39 -0400
Date: Tue, 31 Mar 2009 22:31:28 -0700 (PDT)
Message-Id: <20090331.223128.143365884.davem@davemloft.net>
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Inverted NUMA test in setup_pcpu_remap()?
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The test currently is:

	if (!cpu_has_pse || pcpu_need_numa())
		return -EINVAL;

Don't we really mean "!pcpu_need_numa()"?

The way I read the intent, setup_pcpu_remap() should be used in the
NUMA case.  But that's not what's happening because of how this test
is coded.

In fact, the test here is identical to the one used in
setup_pcpu_embed()
