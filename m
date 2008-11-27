Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYK0PVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYK0PVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYK0PVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:21:32 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:19128 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYK0PVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Xq7YO9XRMCyIJwPDpFlaaT3AGUDsk6dLK60TQIzdL4GpQkYm2CPQ3H86ATrqjjLmF9
         XQECjG87LiG7CMSqKIJhFD1D7Z+psBP9c5A2RL29gnZUfKCZEVSzMNh3ey4WKfUR2i7W
         mW3lvYo9mdwDGbXRyzxOFmDXOJK6EwLVLEqI0=
Date: Thu, 27 Nov 2008 23:21:24 +0800
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: about use wild cards for set_ftrace_filter and so on
Message-ID: <20081127152124.GA24616@ubuntu.mshome.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steven and Ingo,

I encountered an issue when using ftrace.
We know that we can use wild cards to set set_ftrace_filter, but there's 
problem when using such as "echo h* > /debug/tracing/set_ftrace_filter".
If there are files named with "h" prefix in current directory, echo "h*" 
will echo these files' name to set_ftrace_filter, not "h*".
For example:

#cat /debug/tracing/available_filter_functions |grep ^hr |wc -l
23
#ls
#touch hraa hrdd
#ls 
hraa  hrdd
#echo hr* > /debug/tracing/set_ftrace_filter
#cat /debug/tracing/set_ftrace_filter

No output in /debug/tracing/set_ftrace_filter!
If we use "" to enclose wild cards, it works:

#ls 
hraa  hrdd
#echo "hr*" > /debug/tracing/set_ftrace_filter
#cat /debug/tracing/set_ftrace_filter |wc -l 
23

This problem can lead to unexpected result if current directory has a 
lot of files.
I suppose that we can add some notes to document, so a patch attached.
 

--d6Gm4EdcadzBjdND
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Impact-imporve-document.patch"


Impact: imporve document

Signed-off-by: walimis <walimisdev@gmail.com>
---
 Documentation/ftrace.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index de05042..9735434 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -1251,6 +1251,9 @@ These are the only wild cards which are supported.
 
   <match>*<match> will not work.
 
+Note: you'd better to use "" to enclose wild cards, otherwise in some
+case you can't get the correct result.
+
  # echo hrtimer_* > /debug/tracing/set_ftrace_filter
 
 Produces:
-- 
1.6.0.3


--d6Gm4EdcadzBjdND--
