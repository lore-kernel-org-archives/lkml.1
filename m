Return-Path: <linux-kernel-owner+w=401wt.eu-S964814AbZJPAEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbZJPAEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbZJPAEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:04:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:13704 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbZJPAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=OwegVD+LMhab3j2+nzmA+ZmEv0vCAtA3NMKQC5Q39v2ZY2cBjfrT4rptq8/qshlA2T
         86E81kV2+uTWYNW4jqwhmADQF5tQq29s/m5lmnwM4W0hEEdiaAsJNT4V9zvGYs1TBStQ
         nhxmbeFZiVSfYUuy4olN+VmbkZ6IP4IP4UWs0=
Message-ID: <4AD7B838.8030305@gmail.com>
Date: Thu, 15 Oct 2009 18:03:04 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: restorecond going crazy on 2.6.31.4 - inotify regression?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just upgraded to 2.6.31.4 on a CentOS 5.3 x86_64 machine, and noticed 
the SELinux restorecond daemon using 100% CPU. Previously it was running 
2.6.30.7 which didn't have this problem. It looks like it's triggered by 
either opening or closing a gnome-terminal. strace on restorecond shows 
the following repeating continuously

inotify_add_watch(3, "/var/run/utmp", IN_MODIFY|IN_MOVED_FROM) = 9
read(3, "\t\0\0\0\0\200\0\0\0\0\0\0\0\0\0\0", 32768) = 16
write(1, "wd=9 mask=32768 cookie=0 len=0\n", 31wd=9 mask=32768 cookie=0 
len=0
) = 31
open("/var/run/utmp", O_RDONLY)         = 4
fstat(4, {st_mode=S_IFREG|0664, st_size=5760, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7fe0d938c000
read(4, 
"\10\0\0\0\177\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) 
= 4096
read(4, 
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
4096) = 1664
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x7fe0d938c000, 4096)            = 0
inotify_rm_watch(3, 9)                  = 0
inotify_add_watch(3, "/var/run/utmp", IN_MODIFY|IN_MOVED_FROM) = 9

It looks like it's getting continuous notifications that /var/run/utmp 
has changed, which seems a bit odd. I know there were some inotify 
issues in the 2.6.31 series, is there something still amiss?
