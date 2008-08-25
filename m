Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYHYNRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYHYNRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYHYNRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:17:06 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:59721 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753434AbYHYNRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:17:05 -0400
X-Greylist: delayed 2695 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2008 09:17:05 EDT
Date: Mon, 25 Aug 2008 14:32:02 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: nfs4v stalls transfering files, stalls
Message-ID: <20080825123202.GC2497@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I experience oddities with my home nfsv4 client/server
connection which worked long very well. I don't know exactly with which
version it begun. I experienced once in a while, that I delete files but
after rebooting the computers the next day or after doing an ls on the
directory, the files are still there. While I did not take this sriously
first I now have the problem copying an ~600MB avi onto the nfs share.
After 25M or 30M (each time after this amount already transferred) the
connection stalls:

nfs: server 10.10.0.1 not responding, timed out

On my client I have 2.6.17_rc3 and this fstab entry:

10.10.0.1:/pub/ /pub nfs4 tcp,async,hard,intr,noauto,user,sec=sys 0 0

this is only an example, I tried udp, soft and timeo=8 instead of hard
and intr.

On server I had 2.6.25 with this exports:

/exports
10.10.0.0/255.255.0.0(rw,fsid=0,insecure,no_subtree_check,sync)
/exports/pub
10.10.0.0/255.255.0.0(rw,nohide,insecure,no_subtree_check,async)

When this happened, the server had this in dmesg:

RPC: bad TCP reclen 0x0010011a (non-terminal)

or:

RPC: bad TCP reclen 0x3b468abe (large)

In 2.6.27_rc (runnning now), the part in svchost.c was spelled other, it
says now:

RPC: fragment too large: 0x6be367a9
or
RPC: fragment too large: 0x1287087c

Starting the nfs stuff yields into

RPC: multiple fragments per record not supported

with no other regression though.


What can I do to narrow this down?

Kind Regards, Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
