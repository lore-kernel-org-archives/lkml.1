Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbYDJObj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbYDJObj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbYDJOb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:31:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:51073 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755227AbYDJOb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:31:28 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: file offset corruption on 32-bit machines?
Date: Thu, 10 Apr 2008 16:31:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804101631.26149.mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2008 04:01:27 pm Jiri Kosina wrote:
> On Thu, 10 Apr 2008, Michal Hocko wrote:
> > > Jeff Robertson analyzes the behaviour of different operating systems'
> > > 64-bit file offset implementation and concludes that on 32-bit
> > > machines, Linux and Solaris lack any locking to keep the two 32-bit
> > > halves in sync and this could cause rare file offset corruption.
> > > http://jeffr-tech.livejournal.com/21014.html
> >
> > AFAICS, this race is theoretically possible, but it is very hard (almost
> > impossible) to trigger with a sane file usage pattern. Note that you
> > have to access shared struct file (same file descriptor) in different
> > threads which should be synchronized by caller anyway (*).
>
> ... but not in cases the caller is an intentionally evil code, right? :)

Ok, but evil code needs to have access to your struct file and in such a case 
he can do worse things ;)
Or do you have some concrete (innocent looking) example? 

>
> > I also don't see any security implications from this race, but maybe
> > someone with more knowlage about fs can see (f_pos is used at many
> > places in the kernel code).
>
> The f_pos races are in fact exploitable, we've already been there. See
> for example http://www.isec.pl/vulnerabilities/isec-0016-procleaks.txt

This is different race with file position IMO. If I understand the report 
correctly, problem was with sleeping copy_to_user while the f_pos has 
changed.

Best regards
-- 
Michal Hocko
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic 
