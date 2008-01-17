Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYAQLy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYAQLy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 06:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYAQLyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 06:54:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYAQLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 06:54:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: Re: [PATCH] Convert EXT2 to use unlocked_ioctl
Date: Thu, 17 Jan 2008 12:54:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
In-Reply-To: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171254.04071.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19FajlPGv5h0e7zJ9BQgJYUEJ8CYZW5PbOR9ZB
 tMkbPPiZ0Ap9m3YX9vyTa2dJPQjkb6iJez56INSfPsygU/aQTi
 tATnoaSroNe1FZGN64xbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008, you wrote:
> 
> Change ext_ioctl() to be an unlocked_ioctl(), explicitly
> exposing BKL's uses.
> 
> Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>

You are now calling lock_kernel() twice in case of ext2_compat_ioctl(),
which calls back into ext2_ioctl with the BKL already held.

This is allowed with the BKL, but really bad style that you should
avoid. I assume the ext3 and ext4dev versions of your patch have
the same issue, but I didn't check in detail.

	Arnd <><
