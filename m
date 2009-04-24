Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZDXHH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZDXHH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZDXHHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:07:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:33010 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZDXHHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=J3Eb5H7zFtXsvFvMuPxSuwMrkbRtawSf6toeFrm/u41xWCPkMDdpndSOUgzPL0KcA7
         EyZZ2FDGQ3HumcGnNweRTwgYM2etd/JBmlLnELkvJlaBJkt7odmx4WPsHGN3z9BjZ+6w
         LxOXVt048eKqsb4f8NvRvznEwCJobbY/qFB9c=
From: Alessio Igor Bogani <abogani@texware.it>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 0/1] vfs: umount_begin BKL pushdown v2
Date: Fri, 24 Apr 2009 09:06:52 +0200
Message-Id: <1240556813-8739-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090423191934.GW1926@parisc-linux.org>
References: <20090423191934.GW1926@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the BKL acquisition from vfs to every specific filesystems
with hope that it can be eliminated in a second moment.

Filesystems, which support umount_begin(), changed by this patch
are 9p, nfs, cifs and fuse. 

Changes:
Collapsed all patches into only one as requested by Al Viro.

Moved CIFS_SB() down into BKL protected zone as requested by Matthew Wilcox.

It is hard to say if tcon (into cifs's umount_begin() function) should be
protected by BKL. Up to now umount_begin() is always called with BKL held
so in uncertainty I maintain same logic. So I moved unlock_kernel() to at
the bottom of that function as requested by Al Viro and Matthew Wilcox.

Notes:
About cifs's umount_begin() function I suspect that a deadlock or circular
locking dependency can happens into kill-the-BKL tree if that patch is applied.
