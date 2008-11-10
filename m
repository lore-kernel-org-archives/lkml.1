Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYKJClz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYKJClz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 21:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYKJClp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 21:41:45 -0500
Received: from ozlabs.org ([203.10.76.45]:52193 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbYKJClp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 21:41:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18711.40796.201781.605269@drongo.ozlabs.ibm.com>
Date: Mon, 10 Nov 2008 13:41:32 +1100
From: Paul Mackerras <paulus@samba.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/24] perfmon3:  introduction
In-Reply-To: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
References: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

I have just looked through this set of patches and it mostly looks
fine to me.  There is just one thing, and that is that the way you
access bitmaps using cast_ulp() won't work on 32-bit big-endian
machines such as 32-bit PowerPC.  I suggest that instead of using
cast_ulp(), you have a set of abstracted bit-vector operations that
can be implemented by the arch code - and on x86/ia64, they would be
implemented with cast_ulp() + test_bit/__set_bit/etc. as at present.

I hope we can get these patches into 2.6.29.

Regards,
Paul.
