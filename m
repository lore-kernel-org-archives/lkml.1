Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYDVLtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYDVLtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 07:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYDVLtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 07:49:04 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:62073 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYDVLtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 07:49:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AHgeZHkwxK5x60prBa0Mft8z/gw+QG0Vz8EaUlV0LHHtkfmZBKMkbtGH5G3aTQj9WePuBXtQcC6d+Z9PxiZyMIBGI9SIC9h300upFLIKEyCYA2mb8JiDgzrTWiaWd3Msm8mJvDurACU1I7/DT2X9THdocs8bhInGywOiAxULi7Q=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: #define out unused parameters for seven functions in xfs_trans.h
Date: Tue, 22 Apr 2008 13:48:24 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221216.25905.vda.linux@googlemail.com> <200804221320.54147.vda.linux@googlemail.com>
In-Reply-To: <200804221320.54147.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221348.24049.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Seven xfs_trans_XXX functions declared in xfs_trans.h
are not using "tp" parameter in non-debug builds,
but it still takes stack space since these functions
are not static and gcc cannot optimize it out.

This patch removes these parameters using #define hack
which makes them "disappear" without the need of uglifying
every callsite with #ifdefs.

Code size difference on 32-bit x86:
 393441    2904    2952  399297   617c1 linux-2.6-xfs7-TEST/fs/xfs/xfs.o
 393289    2904    2952  399145   61729 linux-2.6-xfs8-TEST/fs/xfs/xfs.o

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda
