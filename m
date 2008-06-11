Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYFKXLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYFKXLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYFKXLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:11:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:2050 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbYFKXLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:11:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=o7HvV2YiVTWp+eUM1EBDfInuwZcUieOnGABdKkmLdRLsXxBCJZSdr0L2jJkR+TVqlz
         GESnysvrgHA58MvRJy13nr0z8bT5qqbLA4XkFHAWPKZ75fY73H54z9z2Ms2iJOjoyBMa
         Fk4+FObkRMXwlW0zbVb+0cgvMGZEU7epg3q08=
Message-ID: <6b53b1990806111611g1e9550d3q5abe1fe96b8ea99b@mail.gmail.com>
Date: Wed, 11 Jun 2008 20:11:01 -0300
From: "Gustavo Fernando Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/signal.c: change vars pid and tgid types to pid_t
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Google-Sender-Auth: 9261b09c41cf702f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5BNBMHl006948

Change the type of pid and tgid variables from int to the POSIX type pid_t.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>

--- a/kernel/signal.c  2008-06-09 23:45:49.000000000 -0300+++ b/kernel/signal.c       2008-06-09 23:52:36.000000000 -0300@@ -1120,7 +1120,7 @@  * is probably wrong.  Should make it like BSD or SYSV.  */
-static int kill_something_info(int sig, struct siginfo *info, int pid)+static int kill_something_info(int sig, struct siginfo *info, pid_t pid) {        int ret;
@@ -2228,7 +2228,7 @@ }
 asmlinkage long-sys_kill(int pid, int sig)+sys_kill(pid_t pid, int sig) {        struct siginfo info;
@@ -2241,7 +2241,7 @@        return kill_something_info(sig, &info, pid); }
-static int do_tkill(int tgid, int pid, int sig)+static int do_tkill(pid_t tgid, pid_t pid, int sig) {        int error;        struct siginfo info;@@ -2284,7 +2284,7 @@  *  exists but it's not belonging to the target process anymore. This  *  method solves the problem of threads exiting and PIDs getting reused.  */-asmlinkage long sys_tgkill(int tgid, int pid, int sig)+asmlinkage long sys_tgkill(pid_t tgid, pid_t pid, int sig) {        /* This is only valid for single tasks */        if (pid <= 0 || tgid <= 0)@@ -2297,7 +2297,7 @@  *  Send a signal to only one task, even if it's a CLONE_THREAD task.  */ asmlinkage long-sys_tkill(int pid, int sig)+sys_tkill(pid_t pid, int sig) {        /* This is only valid for single tasks */        if (pid <= 0)@@ -2307,7 +2307,7 @@ }
 asmlinkage long-sys_rt_sigqueueinfo(int pid, int sig, siginfo_t __user *uinfo)+sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo) {        siginfo_t info;


-- ----------------------------------------------Gustavo Fernando PadovanEngenharia de ComputaÃ§Ã£o 2006LAS - LaboratÃ³rio de AdministraÃ§Ã£o e SeguranÃ§a de SistemasInstituto de ComputaÃ§Ã£o - UNICAMP
gfpadovan@gmail.comra061316@students.ic.unicamp.brpao@jabber.org-------------------------------------------
Seja Livre, use Software Livreÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
