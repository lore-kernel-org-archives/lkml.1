Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYGAWN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYGAWN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYGAWNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:13:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425AbYGAWNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:13:17 -0400
Date: Tue, 1 Jul 2008 15:04:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: dhowells@redhat.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] security: filesystem capabilities bugfix1
Message-Id: <20080701150406.2435593a.akpm@linux-foundation.org>
In-Reply-To: <48635799.3010500@kernel.org>
References: <48635799.3010500@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll assume that patches 1 and 2 are needed in 2.6.26 and that
patches 3 and 4 are for 2.6.27.

Patches 1 and/or 2 caused a reject in
security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch:

***************
*** 350,357 ****
  				bprm->e_gid = current->gid;
  			}
  			if (!capable (CAP_SETPCAP)) {
- 				new_permitted = cap_intersect (new_permitted,
- 							current->cap_permitted);
  			}
  		}
  	}
--- 364,372 ----
  				bprm->e_gid = current->gid;
  			}
  			if (!capable (CAP_SETPCAP)) {
+ 				bprm->cap_post_exec_permitted = cap_intersect(
+ 					bprm->cap_post_exec_permitted,
+ 					current->cap_permitted);
  			}
  		}
  	}

which looked simple to fix.  I'll resend the resulting diff - please
check.

