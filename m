Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYELMQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYELMQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYELMQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:16:37 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49455 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbYELMQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:16:36 -0400
To: linux-kernel@vger.kernel.org
Subject: Does sysrq break something?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200805122116.HIJ51599.VLOFOQFMSFtHJO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 12 May 2008 21:16:30 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm trying to get a sysrq dump when the system hangs.
But unfortunately, typing sysrq key from the keyboard
doesn't work after the system hangs.
So, I'm trying to get a sysrq dump by automatically
writing to /proc/sysrq-trigger using a program.

  #include <stdio.h>
  #include <unistd.h>

  int main(int argc, char *argv[]) {
  	FILE *fp = fopen("/proc/sys/kernel/sysrq", "w");
  	if (!fp) return 1;
  	fprintf(fp, "1\n");
  	fclose(fp);
  	fp = fopen("/proc/sysrq-trigger", "w");
  	if (!fp) return 1;
  	while (1) {
  		sleep(60);
  		fprintf(fp, "t\n");
  		fflush(fp);
  	}
  	return 0;
  }

Is running this program safe?

In other words, does invoking sysrq routine break or taint something?

Regards.
