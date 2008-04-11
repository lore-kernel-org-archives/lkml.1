Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbYDKVoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbYDKVoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYDKVn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:43:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:24779 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbYDKVnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:43:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rMphKxUv+2N8bQbVT77Qr2k+njI4qKXtrwJgie4pdIkSBcrcW7tPHc4WMcy8PeJvuokWvlLVMkrlHmSCtGNHrnEc/4Prim4hXaBawGScLQubPasKfgPmLnThgdrFfkaB86xoOw2JC6q29Dcav1SloIBEa3W8CyuW7dxBsPdG08g=
Message-ID: <7b97a12b0804111443j5ecacfe8i753f54a39093a1ed@mail.gmail.com>
Date: Fri, 11 Apr 2008 18:43:52 -0300
From: "Gary Shi" <garyu.shi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: get a still sysrq-t call trace, not a moving one
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi friends,

when I read sysrq-t call trace, I find the collected call trace for
some cases is not a still snapshot, but a moving one. After checking
show_state src, I realize other cpus are not frozen when one cpu is
doing show_state; thus some task switching can occur among those cpus,
even the cpu doing sysrq for some kind of kernels.

This moving call traces make debugging much more difficult, or even
impossible for some cases, since some tasks have been switched in/out
which make us lose the trace of some important data, like who is
holding a lock when lots of threads are blocked on the lock.

In order to get a still image of sysrq-t call trace,  I'd like to
suggest freezing all other cpus  and disabling irq of local cpu.

Any ideas about this?

Thanx
-gys

pls cc me when you reply since I haven't subscribed to the mailing list.
