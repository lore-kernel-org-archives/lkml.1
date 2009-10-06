Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZJFAGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZJFAGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbZJFAGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:06:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33220 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbZJFAGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:06:50 -0400
Date: Mon, 5 Oct 2009 17:06:31 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] signals: send_signal: use si_fromuser() to detect
	from_ancestor_ns
Message-ID: <20091006000631.GA4390@us.ibm.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021954.GC21006@redhat.com> <20091005181255.GE30442@us.ibm.com> <20091005182536.GA943@redhat.com> <20091005193738.GF30442@us.ibm.com> <20091005194415.GA4560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005194415.GA4560@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| Sorry for confusion.
| 
| > But sure, we could use force_sig_info() in caller.
| 
| Yes, because this makes the code more explicit imho. And we can avoid
| the further complicatiions in send_signal() path.

Although, one small drawback would be the different behavior for the
SIGKILL in load_aout_binary() to the container-init itself calling:

	kill(getpid(), SIGKILL);

(which of course is not very useful).
