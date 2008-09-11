Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbYIKFev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbYIKFev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYIKFen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:34:43 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:48675 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYIKFen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:34:43 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48C8ADEF.9020305@avtrex.com>
Date: Wed, 10 Sep 2008 22:34:39 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/6] MIPS: Hardware watch register support for gdb (version
 4).
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2008 05:34:41.0024 (UTC) FILETIME=[169C5800:01C913D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Esteemed kernel hackers,

To follow is my forth pass at MIPS watch register support.

This version has been tested on:

* MIPS 4KEc (mips32) with a single set of watch registers watchhi not
  reporting I, R, and W conditions.

* MIPS 4KEc (mips32r2) with four sets of watch registers.

* R5000 SGI O2 (mips4 64bit) with no watch register support.

The patches are against 2.6.27-rc6

To use the patch you will need a suitably patched version of gdb.  The
patch against the HEAD of gdb's cvs can be found here:

http://sourceware.org/ml/gdb-patches/2008-09/msg00230.html

The previous version of this patch is here:
http://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=48B71ADD.601%40avtrex.com

The main changes from the previous version are as follows...

* The characteristics of each watch register set are communicated via
  ptrace because according to the mips32 reference, each set can have
  different masks and I, R, W bit support.  Previously only the
  characteristics of the first set were returned.

* The alignment of the structures passed via ptrace are explicitly
  specified as various versions of gcc align 64-bit objects
  differently.

Six patches to follow.

Thanks
David Daney

