Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYHVUy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYHVUy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYHVUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:54:06 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:44768 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbYHVUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=uCHuBeovo4zOt4rsHfYqVq1bwrYm9+LNCj37cdKQeIVH3iCZ3rwgpz+3ckC+xTrFw6
         CXUeTLttlNp6j+v6uFHH9H43AEbPymSDICiPs4nBoYH46T0IGkcswTQITTpB9aTD/JJl
         jz0fZnrsVapE+HsTxdXUTSgWAWsK4LUzBsNCI=
Message-ID: <6278d2220808221354s7b978e28q718a0654cb4b34eb@mail.gmail.com>
Date: Fri, 22 Aug 2008 21:54:03 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [2.6.27-rc4] MAX_LOCK_DEPTH too low...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running some kvm testing on 2.6.27-rc4 with various kernel debug
options enabled, I hit the MAX_LOCK_DEPTH limit of 48:

[   30.670253] uhci_hcd 0000:00:1d.2: FGR not stopped yet!
[   30.701773] uhci_hcd 0000:00:1d.1: FGR not stopped yet!
[   30.733533] uhci_hcd 0000:00:1d.0: FGR not stopped yet!
[   30.765379] uhci_hcd 0000:00:1a.2: FGR not stopped yet!
[   30.797253] uhci_hcd 0000:00:1a.0: FGR not stopped yet!
[  115.469934] uhci_hcd 0000:00:1d.0: FGR not stopped yet!
[  184.507012] Hangcheck: hangcheck value past margin!
[  245.448004] BUG: MAX_LOCK_DEPTH too low!
[  245.448004] turning off the locking correctness validator.
[  260.937296] kvm: emulating exchange as write
[  364.507049] Hangcheck: hangcheck value past margin!
[  544.454998] Hangcheck: hangcheck value past margin!
[  724.507006] Hangcheck: hangcheck value past margin!

Maybe the result of a particular path abusing a lock (ie a bug) even?

Daniel
-- 
Daniel J Blueman
