Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYDDV1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYDDV1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYDDV1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:27:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:62313 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYDDV1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=ssjjrz950IKJ43CCqKxq6bf0eJYWRkly9OrvhS5eghEZ02Vz0tbWdzH+0gGyOXQGkbKC6kKdfNGrHNVwUqGWdo9wMgirx9/+423KJWktWJyY1GpSdIxY5kS71JPtsEq2LIKN+7M14Dfz5yjPJGeSuGOkM3Z01UZCI9mKIZJjY9U=
Message-ID: <47F69D2F.8010607@gmail.com>
Date: Fri, 04 Apr 2008 16:27:11 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Clock has stopped (time/date looping over 5 seconds), things are
 broken - what to check to debug?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far what I have is that the clock is moving between
10:01:03 to 10:01:07 (when it gets to 07 it goes back to 03), doing rdate -s
results in things changing:

16:12:38 to 16:12:43 (resets back to :38).

Doing this:
while true ; do date; usleep 1000000; done
Fri Apr  4 16:12:39 CDT 2008
Fri Apr  4 16:12:40 CDT 2008
Fri Apr  4 16:12:41 CDT 2008
Fri Apr  4 16:12:42 CDT 2008
Fri Apr  4 16:12:43 CDT 2008

It stops at :43, ^C is required, and you can then restart it with repeatable 
results.

This F7 - 2.6.23.15-80.fc7

dmesg/messages contain nothing abnormal.

This machine has done it several times, a freqency of maybe 1x per every couple 
of weeks or so.   I believe it had also done this with: 2.6.22.9-91.fc7 so it
has been doing this for a while.   It used to work with some older kernel (I 
don't know which).

Given what the clock is doing, things that sleep at the wrong time hang forever, 
and a number of other things fail to work.

vmstat 1 results in a single line being printed out, and then a floating point 
exception.

"shutdown -r now" fails to complete, power cycle is required to get the machine
back up.

I don't believe any hardware failure that I can think of would cause the clock 
to do what mine is doing.

Ideas?

                                Roger

