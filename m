Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbYJITk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbYJITk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYJITks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:40:48 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2543 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYJITkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:40:47 -0400
Date: Thu, 9 Oct 2008 21:40:34 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25 on Power5 64bit] badness in fs/sysfs/dir.c:424
Message-ID: <20081009194033.GJ28224@vanheusden.com>
References: <20081009140933.GC28224@vanheusden.com> <20081009122643.0fe3ec07.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009122643.0fe3ec07.randy.dunlap@oracle.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri Oct 10 14:44:58 CEST 2008
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > While running my modprobe-killerscript I got the following in dmesg:
> 
> Where are your scripts, please?

I've got two versions. The one one intel is:
----------------------------------------------------------------------
#! /usr/bin/perl -w

use POSIX;

@mods = <>;

for(;;)
{
        $n = floor(rand(@mods));

        print $mods[$n]."\n";
        if (rand(2) < 1.0)
        {
                system('rmmod ' . $mods[$n]);
        }
        else
        {
                system('modprobe ' . $mods[$n]);
        }
}
----------------------------------------------------------------------
invoked as:
lsmod | awk '{ print $1; }' | ./pyk-perl.mod


The script I used on the power5-platform is:
----------------------------------------------------------------------
#! /usr/bin/perl -w

use POSIX;

@mods = <>;

fork();
fork();

srand(time() ^ getpid() ^ getppid());

for(;;)
{
        $n = floor(rand(@mods));

        print $mods[$n]."\n";
        if (rand(2) < 1.0)
        {
                system('rmmod ' . $mods[$n]);
        }
        else
        {
                system('modprobe ' . $mods[$n]);
        }
}
----------------------------------------------------------------------
invoked as:
lsmod | grep -v -e ibmveth -v -e windfarm_cpufreq_clamp | awk '{ print $1; }' | ./pyk-perl.mod

I'm removing ibmveth from the list or else I would loose connection
during tests and windfarm_cpufreq_clamp because the script would hang
during a modprobe on that. Maybe something to investigate later.


Folkert van Heusden

-- 
To MultiTail einai ena polymorfiko ergaleio gia ta logfiles kai tin
eksodo twn entolwn. Prosferei: filtrarisma, xrwmatismo, sygxwneysi,
diaforetikes provoles. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
