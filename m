Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZDNTgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZDNTgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZDNTgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:36:11 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34163 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZDNTgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=YqZIKhd2rrXhcLjoaA5j/HhlE5CKGxRKb3y99ut/sY2UrY8C3pnUhHiAPyw07b644l
         l9bomFGfyUHkmvGlmlmcWEgWkF9McHOhFdwTyl+pyP5FpEo9R9ZVTw4z1jItB+N2c8u+
         eww3OmZrg4lPLNOK7CpzcJg+pqhe+p8wRdCPU=
Message-ID: <49E4E5A4.80109@gmail.com>
Date: Tue, 14 Apr 2009 21:36:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.2 Thunderbird/3.0b2
MIME-Version: 1.0
To: tyhicks@linux.vnet.ibm.com
CC: kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
       linux-fsdevel@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       xatrix101@gmail.com
Subject: ecryptfs lock loop
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

one student (in CC) found out a suspicioous locking dependence in
ecryptfs code while debugging/running a static lockdep analyzer.

I'm unable to say whether it is only a theoretical issue or a real bug,
any ideas?

Here it comes:

function ecryptfs_send_message:
------------------------------
ecryptfs_daemon_hash_mux <- ecryptfs_msg_ctx_lists_mux
(in function ecryptfs_send_message_locked)

function ecryptfs_wait_for_response:
-----------------------------------
cryptfs_msg_ctx_lists_mux <- msg_ctx->mux

function ecryptfs_process_response:
----------------------------------
msg_ctx->mux <- ecryptfs_daemon_hash_mux


<- means lock dependency
