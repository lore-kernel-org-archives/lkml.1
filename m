Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbZGXHjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbZGXHjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZGXHjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:39:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:26633 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZGXHjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:39:18 -0400
Message-ID: <4A69651E.7040305@monstr.eu>
Date: Fri, 24 Jul 2009 09:39:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: generic uaccess.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

I have just look at asm-generic uaccess.h and there is one thing which
seems to me wrong.

For put_user macro - you use __copy_to_user but you have for 64bit case
ifdef CONFIG_64BIT
but  look at fs/eventfd: eventfd_read function. At least for this
function(syscall) is necessary "return" 64bit
value on 32bit machines too.
IMHO that ifdef CONFIG_64BIT shouldn't be there.

What do you think?
If you agree with me, I'll generate proper patch with description.

Thanks,
Michal


diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index b218b85..bbbb983 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -119,11 +119,9 @@ static inline __must_check long __copy_to_user(void
__user
                case 4:
                        *(u32 __force *)to = *(u32 *)from;
                        return 0;
-#ifdef CONFIG_64BIT
                case 8:
                        *(u64 __force *)to = *(u64 *)from;
                        return 0;
-#endif
                default:
                        break;
                }


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854

