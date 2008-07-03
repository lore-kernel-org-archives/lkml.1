Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYGCUpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYGCUpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbYGCUpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:45:05 -0400
Received: from mail.ccur.com ([12.192.68.12]:39040 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbYGCUpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:45:04 -0400
Message-ID: <486D3A4A.6000502@ccur.com>
Date: Thu, 3 Jul 2008 16:44:58 -0400
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Lee Schermerhorn <lee.schermerhorn@hp.com>, Joe Korty <joe.korty@ccur.com>
Subject: [bug ?] do_get_mempolicy()
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

I'm having unexpected results with get_mempolicy(2) in 2.6.26, and
I am hoping that you can either agree with me, or maybe comment on my
misconceptions.

When I have a task with no special task mempolicy (the default mempolicy),
when I call get_mempolicy(2), it returns a policy value of 2 (MPOL_BIND)
with a NULL nodemask.

I believe that this is because of the code in do_get_mempolicy() that does:

  *policy |= pol->flags;

in the else case when flags do not contain MPOL_F_NODE.

I guess I don't understand why we are ORing in the pol->flags into the
*policy value.  For example, when this is for the default_policy, the
MPOL_F_LOCAL flag (which has a value of 2) gets stuffed into the *policy
location, and a get_mempolicy(2) caller sees this as the MPOL_BIND
mempolicy.

Maybe the "*policy |= pol->flags;" line should be removed ?

That is, maybe it was valid at some point, but subsequent changes
make this line of code no longer valid ?

Sorry if I'm out-to-lunch here...

Thanks very much for you time and considerations on this issue.

