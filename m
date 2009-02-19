Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZBSSXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZBSSXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZBSSXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:23:46 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40803 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZBSSXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:23:45 -0500
Subject: Re: [RFC][PATCH 1/5] create fs flag to mark c/r supported fs's
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090219182007.B4B47C1F@kernel>
References: <20090219182007.B4B47C1F@kernel>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 10:23:41 -0800
Message-Id: <1235067821.26788.44.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, after you apply this and turn on the config option, you do get a
ton of warnings at runtime.  

qemu:~# cat /proc/*/fdinfo/* | grep check  | sort | uniq -c | sort -n 
      1 checkpointable:	0(proc does not support checkpoint)
      6 checkpointable:	0(pipefs does not support checkpoint)
      8 checkpointable:	0(devpts does not support checkpoint)
      9 checkpointable:	0(sockfs does not support checkpoint)
     17 checkpointable:	0(special file)
     17 checkpointable:	1

The special files are /dev/{null,console,xconsole}.  The next step
should probably be to address simple special files like /dev/null.  I
think I'll do that with a new f_op.  Any thoughts?

-- Dave

