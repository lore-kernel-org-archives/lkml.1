Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZLRKzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZLRKzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZLRKzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:55:07 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:61239 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZLRKzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:55:05 -0500
X-Authority-Analysis: v=1.0 c=1 a=BwQm8WjOSfMA:10 a=VwQbUJbxAAAA:8 a=TyFV0zDSf7cC3d85YAoA:9 a=jyujjICLL2-hatd5ZVsA:7 a=1MzGLNhcHGnmRxFlEutBnDtkrRsA:4
X-Cloudmark-Score: 0
X-Originating-IP: 97.102.92.77
Message-ID: <4B2B5F86.1090403@cfl.rr.com>
Date: Fri, 18 Dec 2009 05:55:02 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Mark Hounschell <markh@compro.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, fdutils@fdutils.linux.lu
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B276513.6030509@cfl.rr.com> <4B276753.80807@knaff.lu>	<4B27983F.5090600@compro.net> <4B27EF18.7050101@knaff.lu>	<4B28FDEB.3030800@compro.net> <4B290029.90602@knaff.lu>	<4B2901DB.8040403@compro.net> <4B29052B.9070406@knaff.lu>	<4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu>	<4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu>	<4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net>	<4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net>	<4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net>	<4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net>	<4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu>	<alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain>	<4B2A98BB.5080406@knaff.lu>	<alpine.LFD.2.00.0912171256560.15740@localhost.localdomain>	<4B2AAC87.5000703@knaff.lu>	<alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>	<4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com>
In-Reply-To: <4B2B4485.6000305@cfl.rr.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 03:59 AM, Mark Hounschell wrote:
> On 12/17/2009 06:24 PM, Alain Knaff wrote:
> 
>>
>> Now, I only need to find a machine locally to test this on. Or Mark: are
>> you confident in doing this yourself?
>>
> 
> I'll give it a shot. Sounds easy enough. If I have problems, I'll yell.
> 

Ok, I ran into a build issue on the third on.

#harley:/usr/src # git clone
git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
Initialized empty Git repository in /usr/src/linux-2.6-allstable/.git/
remote: Counting objects: 1486248, done.
remote: Compressing objects: 100% (248092/248092), done.
Receiving objects: 100% (1486248/1486248), 323.35 MiB | 6753 KiB/s, done.
remote: Total 1486248 (delta 1236282), reused 1476516 (delta 1227133)
Resolving deltas: 100% (1236282/1236282), done.
Checking out files: 100% (31502/31502), done.


harley:/usr/src # cd linux-2.6-allstable
harley:/usr/src/linux-2.6-allstable # git bisect start
harley:/usr/src/linux-2.6-allstable # git bisect bad v2.6.28
harley:/usr/src/linux-2.6-allstable # git bisect good v2.6.27.41
Bisecting: a merge base must be tested
[3fa8749e584b55f1180411ab1b51117190bac1e5] Linux 2.6.27

Build and test kernel: This one worked so:

harley:/usr/src/linux-2.6-allstable # git bisect good
Bisecting: 4879 revisions left to test after this (roughly 12 steps)
[c813b4e16ead3c3df98ac84419d4df2adf33fe01] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6

Build and test kernel: This one worked so:

harley:/usr/src/linux-2.6-allstable # git bisect good
Bisecting: 2443 revisions left to test after this (roughly 11 steps)
[db563fc2e80534f98c7f9121a6f7dfe41f177a79] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6

This one doesn't build:

CC [M]  fs/ext3/super.o
fs/ext3/super.c: In function ‘ext3_quota_on’:
fs/ext3/super.c:2839: error: ‘nd’ undeclared (first use in this function)
fs/ext3/super.c:2839: error: (Each undeclared identifier is reported only once
fs/ext3/super.c:2839: error: for each function it appears in.)
make[2]: *** [fs/ext3/super.o] Error 1
make[1]: *** [fs/ext3] Error 2
make: *** [fs] Error 2

I haven't yet determined that I can but, if I were to make a modification to the
tree now to fix this would that screw up the bisect process?

Regards
Mark

