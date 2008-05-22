Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbYEVLAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbYEVLAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYEVLAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:00:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36536 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751925AbYEVLAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:00:31 -0400
Date: Thu, 22 May 2008 11:17:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mahalcro@us.ibm.com, linux-kernel@vger.kernel.org
Subject: BUG: Ecryptfs ioctl handling
Message-ID: <20080522111746.6c78507b@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ecryptfs has an ioctl method that checks for the underlying fs ioctl
method and can call down into. Unfortunately however it doesn't check for
an underlying unlocked_ioctl method and call that if present.

Notices while removing the remaining users of ->ioctl from my dev tree.

Really ecryptfs needs its own ->unlocked_ioctl op to call into either
unlocked ioctl below or lock_kernel/ioctl/unlock_kernel below.

Alan
