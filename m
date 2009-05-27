Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZE0B0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZE0B0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZE0B0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:26:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:61854 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZE0B0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:26:10 -0400
Message-Id: <200905270125.n4R1PS0U031926@www262.sakura.ne.jp>
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: paulmck@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 27 May 2009 10:25:28 +0900
References: <20090503215615.GA1368@ucw.cz> <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp> <200905142108.JIF10080.OOFHJVFtOSQMFL@I-love.SAKURA.ne.jp> <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp> <200905250037.n4P0bFwe057503@www262.sakura.ne.jp> <200905250039.n4P0dSIE058041@www262.sakura.ne.jp> <200905250041.n4P0fVCT058575@www262.sakura.ne.jp> <20090527001613.GE7006@linux.vnet.ibm.com>
In-Reply-To: <20090527001613.GE7006@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 26052009 #2038151, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul E. McKenney wrote:
> The list_del_rcu() primitive is designed for removing elements from
> lists that have concurrent readers, and it therefore avoids changing the
> ->next pointer.  That said, I don't immediately see whether or not there
> is some other reason you need to keep it on the list.  And do you need
> the ->prev pointer to stay valid?  If not, you might be able to use it
> in place of the ->is_deleted flag.

I don't need ->prev pointer.

> > Use of RCU does not help here because we need to keep the item valid as long as
> > the item is referred by ->read_var1 or ->read_var2 or ->write_var1 .
> 
> You would indeed need some way of tracking those references.  One
> approach is to make the RCU callback check to see if any of them
> reference the to-be-deleted object, reposting itself if so.  This
> approach assumes that such a reference is short-lived, of course.
> 
> If the ->read_var1 and other references are long-lived, could you
> post an RCU callback when the last such reference was removed?

The reference stored in ->read_var1 / ->read_var2 / ->write_var1 are long-lived
(it varies from less than one second to more than many hours).

Well, it's time for me to read all Documentation/RCU/* .

Thanks.
