Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXFSJpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXFSJpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXFSJpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:45:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:40617 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbXFSJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=agFHFZFUuL3tKrbMEqDNybUjJo83Jmluqor9pDDcB+S/Au/kr7H1wMhX8FjFPqNrtQeFz1kPlM1+nHxcA3aLU1N6Nmi1cQmIYss4ujpcgT2szYS6tA6KrQV/JtOa1xs6yjoLiDXmKzmwPfx+FHuwdR+5S5M9/71zSg3OExJkg48=
Message-ID: <4677A596.7090404@gmail.com>
Date: Tue, 19 Jun 2007 18:44:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: David Chinner <dgc@sgi.com>, David Robinson <zxvdr.au@gmail.com>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com>
In-Reply-To: <4677A0C7.4000306@dgreaves.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

David Greaves wrote:
>> Good :)
> Now, not so good :)

Oh, crap.  :-)

> So I hibernated last night and resumed this morning.
> Before hibernating I froze and sync'ed. After resume I thawed it. (Sorry
> Dave)
> 
> Here are some photos of the screen during resume. This is not 100%
> reproducable - it seems to occur only if the system is shutdown for
> 30mins or so.
> 
> Tejun, I wonder if error handling during resume is problematic? I got
> the same errors in 2.6.21. I have never seen these (or any other libata)
> errors other than during resume.
> 
> http://www.dgreaves.com/pub/2.6.22-rc5-resume-failure.jpg
> (hard to read, here's one from 2.6.21
> http://www.dgreaves.com/pub/2.6.21-resume-failure.jpg

Your controller is repeatedly reporting PHY readiness changed exception.
 Are you reading the system image from the device attached to the first
SATA port?

> I _think_ I've only seen the xfs problem when a resume shows these errors.

The error handling itself tries very hard to ensure that there is no
data corruption in case of errors.  All commands which experience
exceptions are retried but if the drive itself is doing something
stupid, there's only so much the driver can do.

How reproducible is the problem?  Does the problem go away or occur more
often if you change the drive you write the memory image to?

-- 
tejun
