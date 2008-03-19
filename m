Return-Path: <linux-kernel-owner+w=401wt.eu-S937250AbYCSV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937250AbYCSV1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYCSUCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:02:19 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:38639 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762420AbYCSUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:02:17 -0400
Date: Wed, 19 Mar 2008 15:12:12 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andrew Morgan <morgan@kernel.org>,
       buraphalinuxserver@gmail.com
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill() (-git)
Message-ID: <20080319151212.571c4f72@mandriva.com.br>
In-Reply-To: <20080319165635.GH5935@sergelap.ibm.com>
References: <20080319165635.GH5935@sergelap.ibm.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 19 Mar 2008 11:56:35 -0500
"Serge E. Hallyn" <serue@us.ibm.com> escreveu:

| (resending once against -git.  I had sent against -stable in
| http://lkml.org/lkml/2008/2/28/225.  Without this patch,
| atd is broken at least on some distros.)
| 
| The original justification for cap_task_kill() was as follows:
| 
| 	check_kill_permission() does appropriate uid equivalence checks.
| 	However with file capabilities it becomes possible for an
| 	unprivileged user to execute a file with file capabilities
| 	resulting in a more privileged task with the same uid.
| 
| However now that cap_task_kill() always returns 0 (permission
| granted) when p->uid==current->uid, the whole hook is worthless,
| and only likely to create more subtle problems in the corner cases
| where it might still be called but return -EPERM.  Those cases
| are basically when uids are different but euid/suid is equivalent
| as per the check in check_kill_permission().
| 
| One example of a still-broken application is 'at' for non-root users.
| 
| This patch removes cap_task_kill().
| 
| Signed-off-by: Serge Hallyn <serge@hallyn.com>
| Acked-by: Andrew G. Morgan <morgan@kernel.org>

 I've tested the -stable patch (no time to test this one, but it's
exactly the same patch), not sure if this applies to this but...

Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

-- 
Luiz Fernando N. Capitulino
