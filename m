Return-Path: <linux-kernel-owner+w=401wt.eu-S1751335AbZJVXXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbZJVXXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 19:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZJVXXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 19:23:42 -0400
Received: from smtp.cs.ubc.ca ([142.103.6.52]:51656 "EHLO smtp.cs.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbZJVXXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 19:23:41 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2009 19:23:41 EDT
Message-ID: <4AE0E7C9.5070705@cs.ubc.ca>
Date: Thu, 22 Oct 2009 16:16:25 -0700
From: "Charles 'Buck' Krasic" <krasic@cs.ubc.ca>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: asinha@zeugmasystems.com
Subject: [RFC] Cooperative Polling - an alternative for real time scheduling
 and deadlines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The good folks at lwn.net have recently published a nice article about
deadline scheduling and Linux.

My colleagues and I have developed a new scheduler for Linux that may
be of interest.   Our approach is called cooperative polling.   It
consists new scheduler for Linux and a new system call "coop_poll".
Applications use coop_poll to explicitly communicate timing
information (release times, virtual execution time) to and from the
kernel.  Our scheduler is not a deadline scheduler in the classic
sense, but it does share some characteristics.   Notably, it allows
applications to communicate times (not deadlines in our case, but
release-times) directly to the kernel scheduler, as opposed to using
priority based scheduling.    Unlike deadline scheduling, we are not
shooting for hard guarantees,  we don't require nor do we support
schedulability analysis.    Our approach looks to fit real-time and
best-effort processes together in a sensible way.     Our cooperative
tasks can get good timing, but not with the risk of starving everyone
else.

We presented our ideas earlier this year at the Eurosys 2009
conference.   The talk slides and paper are available here:

           http://qstream.org/coop/

The basic premise of our approach is that if time-sensitive
applications pro-actively supply timing information to the kernel, it
is possible to employ cooperative scheduling that is more responsive
(processes run when they want to), and more efficient (fewer un-
necessary context switches) than existing techniques that use
heuristics and purely pre-emptive scheduling.   We still use pre-
emption to ensure fairness, and prevent misbehaviour, but we believe
it is quite natural for time-sensitive applications to cooperate
properly.   In the paper, we describe how this works for a video streaming
application, and also we modified the X server to use coop poll.    We
do require applications be modified, which may be easy for some or
hard for others.    I do believe our model could suit a broad range of
time-sensitive applications.

We're very interested in any feedback.

-- Buck

Charles 'Buck' Krasic
Assistant Professor
Department of Computer Science
University of British Columbia

ps The patch (for 2.6.26.5) is available at the above link too.   I'm mainly
interested to get feedback on the ideas though.   The code is very
rough, it's typical research code produced by graduate students.   It
needs a lot of cleanup and polish.  Also, if anyone is brave enough to
read the code closely, I'll warn that much of the terminology in the
paper differs from the code.

