Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZAISDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZAISDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZAISCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:02:48 -0500
Received: from gateway.heeltoe.com ([66.134.219.32]:10629 "EHLO
	mini.heeltoe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752715AbZAISCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:02:47 -0500
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 13:02:47 EST
From: Brad Parker <brad@heeltoe.com>
To: linux-kernel@vger.kernel.org
Subject: copy_{to,from}_user
Organization: Heeltoe Consulting
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.2.1
Date: Fri, 09 Jan 2009 12:52:37 -0500
Message-ID: <4056.1231523557@mini>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a question about copy_{to,from}_user.  

Most implementations I've seen do in-order copies and notice when an
exception occurs and report back the progress.  This is straight
forward.

(but to be honest, I have suspicions about how just how accurate those
reports are i.e. +/- 1-3 bytes on some architectures)

On some cpu's it is advantageous to do an out-of-order copy to take
advantage of various cache fill mechanisms.

The problem is that the out-of-order copy makes it impossible to know
where the exception occurred (in terms of progress).

Would it be permissible to have a version of copy_{to,from}_user which
does an out-of-order copy and when an exception occurs, restarts the
copy from the beginning using a simple in-order copy, to make it
possible to identify where the exception occurs?

The idea is that exceptions are rare and so the performance hit of doing
the "recopy" would be minimal and would provide the required accuracy.

-brad

