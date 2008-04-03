Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYDCFq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYDCFq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYDCFqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:46:50 -0400
Received: from smtp.ertelecom.ru ([212.33.232.210]:63361 "EHLO
	smtp.ertelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbYDCFqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:46:49 -0400
Message-ID: <47F46F3A.3060105@permonline.ru>
Date: Thu, 03 Apr 2008 11:46:34 +0600
From: "Artem S. Tashkinov" <birdie@permonline.ru>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Recreating RAID1 after the reckless mdadm usage
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have initially created RAID1 in a wrong way:

mdadm --create --verbose /dev/md0 --level=1 --force --raid-devices=1 
/dev/sda1

Note the --raid-devices=1 option and nowhere to be found 'missing' argument.

People have told me I wouldn't be able to add another partition to have 
a working RAID1. Unfortunately, I've already populated /dev/md0 with a 
great deal of data.

Then I did this:

mdadm --stop /dev/md0
mdadm --create --assume-clean --verbose /dev/md0 --level=1 --force 
--raid-devices=2 /dev/sda1 missing (which is obviously the right command).

After doing that I see that my data on a recreated /dev/md0 is there (It 
seems like it's intact). Is it safe to use this RAID1 and is my data 
safe? Can I now add the second block device to md0 using 'mdadm /dev/md0 
-a /dev/sdb1' command?

With respect,

Artem S. Tashkinov
