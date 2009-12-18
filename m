Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZLRNtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZLRNtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZLRNtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:49:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48235 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZLRNtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:49:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=kTrbylrh+TCgm7ctg0olK3Iwb+3DIee6D6exznSACn/wJCe0xh1dBhyF1uSilSmYw2
         62GCfZOzTdeJMXhrU3yLN9hgwexntivl+rosRPtsD7Xb9/5PeWQSd3b1QpL9GbOVHA7i
         K4/pt2Z57Veji3QAYPQMboBChSTgUdiSDvV5Q=
MIME-Version: 1.0
Date: Fri, 18 Dec 2009 15:49:18 +0200
Message-ID: <b6fcc0a0912180549u6970ceden53dc919bae52452e@mail.gmail.com>
Subject: intelligent CLS kills qemu's 8139cp
From: Alexey Dobriyan <adobriyan@gmail.com>
To: jbarnes@virtuousgeek.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch qemu's 8139cp won't be initialized resulting in no network.
It einvals in pci_set_cacheline_size() where pci_cache_line_size=0

PCI: CLS 0 bytes, default 32

ac1aa47b131416a6ff37eb1005a0a1d2541aad6c is first bad commit
commit ac1aa47b131416a6ff37eb1005a0a1d2541aad6c
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Oct 26 13:20:44 2009 -0700

    PCI: determine CLS more intelligently
