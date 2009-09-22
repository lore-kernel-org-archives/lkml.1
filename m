Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZIVNit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZIVNit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZIVNis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:38:48 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:47005 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbZIVNir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:38:47 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-modules@vger.org
Subject: module: Speed up symbol resolution during module loading
Date: Tue, 22 Sep 2009 14:38:34 +0100
Message-Id: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Apologies for duplicate messages. It's debatable whether I should be trusted
 with commands called names like "guilt-patchbomb". ]

The following series applies against v2.6.31. It sorts the tables of builtin
symbols, so the module loader can resolve them using a binary search.

The kbuild changes to achieve this are less scary than I expected.  I'm
optimistic that they can be accepted without radical alteration  :-) .

Quoting from the last patch in this series:

"On my EeePC 701, coldplug is mainly cpu bound and takes 1.5 seconds
during boot. perf showed this change eliminated 20% of cpu cycles during
coldplug, saving 0.3 seconds of real time.

These savings may not be representative since my config is not very well
tuned.  The numbers above represent the loading of 35 modules,
referencing a total of 441 symbols.  Nevertheless, it shows why I think
this is worth doing."

Alan

