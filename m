Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZELNLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZELNLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZELNLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:11:02 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56822 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZELNLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ZSgawm4gPdwkVW8QwdmO6sgUUO5ZRkux+DkkLe+AFQu9Am1n3S9OiulgUaIs0COkA1
         JoczXICoTFhmBUdrFUX8Xsgaxl3jrqbqkVHOjDnTE2qbQagHyM2fcEUHnvmuDEU7tNRR
         2prOtLf58sKIleJqShZdVXYCImbiB/SAt2pCs=
From: Alessio Igor Bogani <abogani@texware.it>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: FSDEV <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH vfs-2.6:for-next] Push BKL down into ->remount_fs() v2
Date: Tue, 12 May 2009 15:10:53 +0200
Message-Id: <1242133854-4872-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the BKL acquisition from vfs to every specific filesystems
with hope that it can be eliminated in a second moment.

Changes from previous version:

Removed useless BKL from some filesystems which don't require it.

Reduced BKL acquisition as short as possible.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
