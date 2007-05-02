Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbXEBI0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbXEBI0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXEBI0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:26:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60961 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751762AbXEBI0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:26:50 -0400
Date: Wed, 2 May 2007 01:26:47 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: torvalds@linux-foundation.org, menage@google.com,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: allow empty {cpus,mems}_allowed to be set for
 unpopulated cpuset
Message-Id: <20070502012647.fbc0d502.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705011714490.6376@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705011714490.6376@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Other than the detail of allowing a newline from doing:

	echo > cpus

to work, I'm ok with this patch.  It passes my cpuset_test,
and seems to allow unpopulating cpusets, as advertised.

Aha - as I was writing this, I noticed that the command:

  echo -n '' > cpus

does -not- work!  The echo command recognizes that as a write
of zero non-null bytes, and skips the write altogether.

We have to add the code to handle an input line consisting of
just a bare newline, to mean an empty mask.  Well, we don't
-have- to.  But writing a single nul byte in shell script will
challenge most shell script hackers.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
