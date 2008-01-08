Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbYAHSRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbYAHSRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYAHSRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:17:16 -0500
Received: from SMTP.andrew.cmu.edu ([128.2.10.83]:36340 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbYAHSRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:17:15 -0500
X-Greylist: delayed 790 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 13:17:15 EST
Message-ID: <4783BB41.4010707@cmu.edu>
Date: Tue, 08 Jan 2008 13:04:49 -0500
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: hanging in fsync for 3+ seconds
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I noticed that all of a sudden my disk writes using VIM/EMACS are taking 
3+ seconds for even just a single byte.  So, I've used strace to narrow 
it down to fsync.

The following log is an fsync opening up a new file 'test' inserting a 
't' and writing and quitting in vim:
   http://www.andrew.cmu.edu/user/gnychis/slog

If you do a search for the only fsync, you will see it takes more than 3 
seconds:
   15171      0.000094 fsync(6)            = 0 <3.386504>

What can I do to determine why the fsync is taking so long?  I am not 
getting any disk error messages in system logs.

Info about my system:
   Ubuntu Gutsy Gibbon desktop machine, updated as of last night
   Linux 2.6.22-14-generic #1 SMP i686 GNU/Linux, running reiserFS.

Thanks!
George
