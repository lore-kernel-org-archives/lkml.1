Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYEBGzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYEBGzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYEBGzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:55:44 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:38720 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYEBGzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=lciZfHZEjqMuxesKvtRUr9aapEPBE1V7he/fe+jon0h9p0TnY5ohBUJbfscjnetKhIwmnShaZfccXHvz73K4CogV/QBDFzAlVWKOsdW4F5u2D+Dabu45tIB5J5IHSFACdcJIFaiKMRDhkbUC83B+aL0GdK30JiOXlkfVnM+Uo6M=
Date: Fri, 2 May 2008 14:59:46 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [Patch] UML: Fix inconsistence due to tty_operation change
Message-ID: <alpine.LFD.1.10.0805021450260.3349@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'put_char' of 'struct tty_operations' has changed from 'void' into 'int'.
This can also shut up comipler warnings.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 10b86e1..5047490 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -191,9 +191,9 @@ void line_flush_chars(struct tty_struct *tty)
  	line_flush_buffer(tty);
  }

-void line_put_char(struct tty_struct *tty, unsigned char ch)
+int line_put_char(struct tty_struct *tty, unsigned char ch)
  {
-	line_write(tty, &ch, sizeof(ch));
+	return line_write(tty, &ch, sizeof(ch));
  }

  int line_write(struct tty_struct *tty, const unsigned char *buf, int len)
diff --git a/arch/um/include/line.h b/arch/um/include/line.h
index 1223f2c..979b73e 100644
--- a/arch/um/include/line.h
+++ b/arch/um/include/line.h
@@ -71,7 +71,7 @@ extern int line_setup(struct line *lines, unsigned int sizeof_lines,
  		      char *init, char **error_out);
  extern int line_write(struct tty_struct *tty, const unsigned char *buf,
  		      int len);
-extern void line_put_char(struct tty_struct *tty, unsigned char ch);
+extern int line_put_char(struct tty_struct *tty, unsigned char ch);
  extern void line_set_termios(struct tty_struct *tty, struct ktermios * old);
  extern int line_chars_in_buffer(struct tty_struct *tty);
  extern void line_flush_buffer(struct tty_struct *tty);
