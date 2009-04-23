Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbZDWTMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbZDWTMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZDWTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:12:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61329 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZDWTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=JekwCQ5zxu5xT+2ozo186LRvUuubg0M1GxukQjfGlie4y4h6rndUSzi2e2qDx/wZMs
         h9fcXbzo+Vler5o5Skb5SCO5PZIOc8qHxe18HarALsGOuDXwyIBHQfwLDSeC4BPUFgUm
         PctMjdn9AutSwzrTmrxgsnrXdf5j0P2yMpSJQ=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 0/5 -tip] umount_begin BKL pushdown
Date: Thu, 23 Apr 2009 21:12:00 +0200
Message-Id: <1240513925-5603-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the BKL acquisition from vfs to every specific filesystems
with hope that it can be eliminated in a second moment.

The first 4 patches add BKL lock into umount_begin() functions (for
the filesystems that have this handler). The last one remove
lock_kernel()/unlock_kernel() from fs/namespace.c (the only point
that invoke umount_begin() funtcions).
