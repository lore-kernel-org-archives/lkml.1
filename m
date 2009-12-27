Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZL0Bjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZL0Bjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 20:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZL0Bjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 20:39:31 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:61444 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbZL0Bja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 20:39:30 -0500
To: michael@laptop.org, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] Security: Document disablenetwork. (v4)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091227010441.GA12077@heat>
	<20091227010708.GA12216@heat>
In-Reply-To: <20091227010708.GA12216@heat>
Message-Id: <200912271039.DHG51586.FMFFHOJSLVQtOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 27 Dec 2009 10:39:28 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote
> sendmsg(fd, (struct sockadr *) &addr, sizeof(addr));
I meant
sendto(fd, buffer, len, 0, (struct sockadr *) &addr, sizeof(addr));

Michael Stone wrote:
> +Exceptions are made for
> +  * processes calling sendmsg() on a previously connected socket
> +      (i.e. one with msg.msg_name == NULL && msg.msg_namelen == 0) or

What should we do for non connection oriented protocols (e.g. UDP)
but destination is already configured by previous connect() request?

struct sockaddr_in addr = { ... };
int fd2 = socket(PF_INET, SOCK_DGRAM, 0);
connect(fd2, (struct sockadr *) &addr, sizeof(addr));
prctl( ... );
sendto(fd2, buffer, len, 0, NULL, 0); /* Should we allow this? */
sendto(fd2, buffer, len, 0, (struct sockadr *) &addr, sizeof(addr)); /* Should we reject this? */
