Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZHGKHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZHGKHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbZHGKHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:07:32 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:38968 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZHGKHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=T9E9nT4lbCLaWFN4xhRMmZjYUZvpXJ/XLySHZ3Um7b8qAeLfA6PADAldRPkY63egMl
         cQPoiqTSgFpddRW20Qsf/YUy4AvkUHlsI1aotS9w7w1taiThFhbGXZVpgGNQM6d4CUi9
         mwBQvBg+QF9o2iFXcFATMdVh6F4HQiH4vaiw4=
MIME-Version: 1.0
Date: Fri, 7 Aug 2009 18:07:30 +0800
Message-ID: <113d36d80908070307o340aee88s956e6e1ee02c0b77@mail.gmail.com>
Subject: sco connection issue for BlueZ 4.x on kernel 2.6.29
From: Lan Zhu <zhu.lan.cn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can not accept incoming SCO connection. Kernel version 2.6.29. Kernel
log is as below. Is this a kernel bug? Is there any fix already for
this?

<6>[  158.339691] sco_connect_ind: hdev hci0, bdaddr CA:D3:10:55:0C:00
      -------// receive incoming sco
<6>[  158.518554] sco_connect_cfm: hcon cf18ee00 bdaddr CA:D3:10:55:0C:00 status
<6>[  158.721160] sco_connect_cfm: hcon cf149c00 bdaddr CA:D3:10:55:0C:00 status
<6>[  158.728851] sco_conn_add: hcon cf149c00 conn cc772640
<6>[  158.734313] sco_conn_ready: conn cc772640
-----------// handle sco connection complete
<6>[  158.738800] sco_sock_init: sk cf18c400
-----------// start handle sco socket
<6>[  158.742858] __sco_chan_add: conn cc772640
<6>[  159.693023] sco_sock_accept: sk ccfdf400 timeo 0
<6>[  159.708038] sco_sock_accept: new socket cf18c400
<6>[  159.713073] sco_sock_getsockopt: sk cf18c400
<6>[  159.717834] sco_sock_getsockopt_old: sk cf18c400
<6>[  159.722839] sco_sock_getsockopt_old: mtu 180
<6>[  159.727661] sco_sock_getname: sock ce9d80a0, sk cf18c400
<6>[  159.733398] sco_sock_getname: sock ce9d80a0, sk cf18c400
<6>[  159.739166] sco_sock_release: sock ce9d80a0, sk cf18c400
-----------// don't know why it call sco_sock_release
<6>[  159.745025] sco_sock_clear_timer: sock cf18c400 state 1
<6>[  159.750671] sco_sock_close: sk cf18c400 state 1 conn cc772640 socket ce9d8
<6>[  159.758453] sco_chan_del: sk cf18c400, conn cc772640, err 104
<6>[  159.764770] sco_sock_kill: sk cf18c400 state 9
<6>[  159.769592] sco_sock_destruct: sk cf18c400
------------// destruct sco socket, and disconnect SCO connection
<6>[  159.782745] l2cap_disconn_ind: hcon cf149c00
<6>[  159.787384] hci_acl_disconn: cf149c00
<6>[  159.950805] hci_disconn_complete_evt: hci0 status 0
<6>[  159.956207] l2cap_disconn_cfm: hcon cf149c00 reason 22
<6>[  159.961730] sco_disconn_cfm: hcon cf149c00 reason 22
-------------// sco disconnected
<6>[  159.967102] sco_conn_del: hcon cf149c00 conn cc772640, err 103
<6>[  162.130523] hci_disconn_complete_evt: hci0 status 0
<6>[  162.136291] l2cap_disconn_cfm: hcon cf18ee00 reason 19
<6>[  162.149871] sco_disconn_cfm: hcon cf18ee00 reason 19
<4>[  165.382141] done EDISCO CTRL ENABLE
<7>[  165.386077] sholes-panel:  edisco_ctrl_enable_te

Thanks,
Zhu Lan
