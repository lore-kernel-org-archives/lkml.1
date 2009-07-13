Return-Path: <linux-kernel-owner+w=401wt.eu-S1751214AbZGMFmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbZGMFmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 01:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZGMFmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 01:42:49 -0400
Received: from main.gmane.org ([80.91.229.2]:57752 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZGMFms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 01:42:48 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockrwd@gmail.com>
Subject: Floppy constantly accessed in 2.6.31-rc2
Date: Sun, 12 Jul 2009 23:44:19 -0600
Message-ID: <h3ehgd$mti$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.31-rc2 (actually current git as of today) the floppy drive is 
constantly being accessed with these messages being reported:

Platform driver 'floppy' needs updating - please use dev_pm_ops
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0

lsof reports no process with /dev/fd0 open so it is not clear what is 
causing this activity. It looks like the access starts when I log in to 
X, but doesn't stop when I log out. I'm guessing HAL or something checks 
the floppy drive and then the kernel somehow gets stuck in a loop 
retrying the request..

Anyone have any ideas what might be causing this? Commit 
5e50b9ef975219304cc91d601530994861585bfe seemed a bit suspicious but 
reverting it didn't seem to help. (It did get rid of the dev_pm_ops 
message, though..)

