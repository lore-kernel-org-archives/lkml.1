Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZL0BUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZL0BUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 20:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZL0BUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 20:20:13 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54881 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbZL0BUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 20:20:12 -0500
To: michael@laptop.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091227010441.GA12077@heat>
	<20091227010650.GA12190@heat>
In-Reply-To: <20091227010650.GA12190@heat>
Message-Id: <200912271020.III12990.JSHOOQOMtFLFFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 27 Dec 2009 10:20:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone wrote:
> +int disablenetwork_security_socket_sendmsg(struct socket * sock,
> +					   struct msghdr * msg, int size)
> +{
> +	if (sock->sk->sk_family != PF_UNIX &&
> +		current->network &&
> +		(msg->msg_name != NULL || msg->msg_namelen != 0))
> +		return -EPERM;
> +	return 0;
> +}

I think we should accept msg->msg_name != NULL || msg->msg_namelen != 0
if the socket is connection oriented protocols (e.g. TCP).

struct sockaddr_in addr = { ... };
int fd = socket(PF_INET, SOCK_STREAM, 0);
connect(fd, (struct sockadr *) &addr, sizeof(addr));
prctl( ... );
sendmsg(fd, (struct sockadr *) &addr, sizeof(addr));
