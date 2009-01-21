Return-Path: <linux-kernel-owner+w=401wt.eu-S1763574AbZAUJjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763574AbZAUJjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZAUJjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:39:13 -0500
Received: from fxip-0059e.externet.hu ([88.209.247.158]:50477 "EHLO
	teledigit.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754079AbZAUJjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:39:11 -0500
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 04:39:10 EST
X-AuthUser: kgy@teledigit.hu
From: =?utf-8?q?K=C3=B6vesdi_Gy=C3=B6rgy?= <kgy@teledigit.hu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28(.1) and netlink: scheduling while atomic
Date: Wed, 21 Jan 2009 10:29:01 +0100
User-Agent: KMail/1.9.9
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901211029.01619.kgy@teledigit.hu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The new netlink interface allows to add NAT directly to a conntrack entry.
If it is used when the moudule nf-nat-ipv4 is not loaded in, it results in 
crash:
BUG: scheduling while atomic
It is in the kernels 2.6.28 and 2.6.28.1 in the function 
ctnetlink_parse_nat_setup(): it calls request_module() which causes the 
problem. If the module is already loaded, then there is no problem.

Regards:
K. Gy.
