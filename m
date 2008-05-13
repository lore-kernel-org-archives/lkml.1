Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYEMGev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYEMGev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbYEMGeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:34:44 -0400
Received: from mailout03.t-online.de ([194.25.134.81]:39618 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbYEMGen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:34:43 -0400
X-Greylist: delayed 1033 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 02:34:43 EDT
Message-ID: <4829326A.6060808@t-online.de>
Date: Tue, 13 May 2008 08:17:14 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080503)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.25.3: su gets stuck for root
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: E9bhgyZeQhTgtl0VO6BBkwpfwPYd-PtPAK+j9dSd9vttP5RYZckmLqPM-oM16pHZOS
X-TOI-MSGID: d0f14bce-82e5-46c4-89e0-d9aa50e199fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I haven't seen it mentioned here (hopefully I wasn't too blind to see):

If I run "su someuser" as root, then it gets stuck. No prompt. I cannot
interrupt it with ^C or ^Z either. /var/log/auth.log says:

May 13 08:06:41 pluto su[4193]: Successful su for root by harri
May 13 08:06:41 pluto su[4193]: + pts/3 harri:root
May 13 08:06:41 pluto su[4193]: pam_unix(su:session): session opened for user root by harri(uid=1000)

ps shows:

% ps -ef | grep pts/3
harri     4007  4006  0 07:58 pts/3    00:00:00 bash
root      4193  4007  0 08:06 pts/3    00:00:00 su
root      4194  4193  0 08:06 pts/3    00:00:00 bash
root      4209  4194  0 08:08 pts/3    00:00:00 su
root      4210  4209  0 08:08 pts/3    00:00:00 bash
root      4217  4210  0 08:08 pts/3    00:00:00 stty intr ^C

So obviously 'stty' is to blame here (called from root's .bashrc, as
it seems). But for 2.6.24.4 there is no such problem.


Maybe you could spread some light here?


Regards

Harri

