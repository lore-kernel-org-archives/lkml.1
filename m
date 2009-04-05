Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZDEIrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZDEIrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 04:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZDEIq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 04:46:56 -0400
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:36174 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbZDEIqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:46:55 -0400
Message-ID: <49D86FFA.1010507@numericable.fr>
Date: Sun, 05 Apr 2009 10:46:50 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
CC: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] security/smack implement logging V2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the following 2 patches implements auditing of security events for Smack.
It tries to implement what Eric Paris suggested, and moves shareable code
to include/linux/lsm_audit.h and security/lsm_audit.c.
Smack specific logging functions are now defined in smack_access.c

patch 1 : created common LSM auditing code 
patch 2 : convert smack to use it

the patches are against current mainline
thanks,
Etienne

sample logs produced :

type=1400 audit(1238919766.161:13): SMACK[smack_netlabel_send]: action=denied subject="FOO" object="BAR" requested=w pid=6672 comm="telnet" daddr=212.180.1.1 dest=80
type=1400 audit(1238919813.116:21): SMACK[smack_inode_getattr]: action=denied subject="FOO" object="etienne" requested=r pid=6679 comm="bash" path="/home/etienne/Desktop" dev=sda8ino=1237000
type=1400 audit(1238919813.773:22): SMACK[smack_inode_permission]: action=denied subject="FOO" object="_" requested=wx pid=6691 comm="rm"name="etienne" dev=sda8 ino=1236993
type=1400 audit(1238919842.953:30): SMACK[smack_task_kill]: action=denied subject="FOO" object="_" requested=w pid=6679 comm="bash"pid=6466 comm="thunderbird-bin"
type=1400 audit(1238920571.962:52): SMACK[smack_sb_mount]: action=denied subject="FOO" object="_" requested=w pid=6835 comm="mount" path="/debug" dev=sda5 ino=16161
type=1400 audit(1238920971.805:10435): SMACK[smack_socket_sock_rcv_skb]: action=granted subject="_" object="_" requested=w saddr=77.199.172.15 src=8541 daddr=192.168.0.10 dest=36917 netif=eth0



