Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYAQL7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYAQL7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 06:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYAQL71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 06:59:27 -0500
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:55072
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYAQL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 06:59:26 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com
Subject: Re: [PATCH] Convert EXT2 to use unlocked_ioctl
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
	<200801171254.04071.arnd@arndb.de>
From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Date: Thu, 17 Jan 2008 12:59:25 +0100
In-Reply-To: <200801171254.04071.arnd@arndb.de> (Arnd Bergmann's message of "Thu\, 17 Jan 2008 12\:54\:03 +0100")
Message-ID: <87myr4ek82.fsf@barad-dur.regala.cx>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vous m'avez dit récemment :

> On Thursday 17 January 2008, you wrote:
>> 
>> Change ext_ioctl() to be an unlocked_ioctl(), explicitly
>> exposing BKL's uses.
>> 
>> Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
>
> You are now calling lock_kernel() twice in case of ext2_compat_ioctl(),
> which calls back into ext2_ioctl with the BKL already held.
>
> This is allowed with the BKL, but really bad style that you should
> avoid. I assume the ext3 and ext4dev versions of your patch have
> the same issue, but I didn't check in detail.

yep, they do. I noticed this nested calls. I guess I will add
_extX_compat_ioctl() running with no BKL's which would be used by both
extX_ioctl() and extX_compat_ioctl().
Any comments on such a strategy ? thanks a lot for the reminder :)

-- 
Mathieu

ps: I just posted a set of patches for reiserfs that may suffer the
same ugly style
