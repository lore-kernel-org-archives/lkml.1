Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZBXVtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZBXVtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZBXVt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:49:26 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:59781 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZBXVt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:49:26 -0500
To: etienne.basset@numericable.fr
Cc: casey@schaufler-ca.com, paul.moore@hp.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH][SMACK] add a socket_post_accept hook to fix netlabel issueswith labeled TCP servers V1
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <49A46678.1030803@numericable.fr>
In-Reply-To: <49A46678.1030803@numericable.fr>
Message-Id: <200902250649.BIF17188.FFOLSVOtJQHOMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 25 Feb 2009 06:49:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> The following patch  adds a "post_access" hook to get the client IP and check it against the netlabel list. 

Oh, SMACK starts to use security_socket_post_accept() hook?

Then why not move security_socket_post_accept() to before fd_install()?
If file descriptor table is shared between multiple processes,
another process can reach not-yet-labeled-by-security_socket_post_accept()
accept()ed socket.

(Well, I'm happy if security_socket_post_accept() can return error
because TOMOYO wants to implement personal firewall.)
