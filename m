Return-Path: <linux-kernel-owner+w=401wt.eu-S1765439AbYEBA7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765439AbYEBA7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbYEBA7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:59:15 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:37146 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754992AbYEBA7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:59:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=E049X3evf9JiYRXFLUDeGxNIVhcm8rVzasA1w5Kd0BX0xpvMsppGD6FAtKrrWghrG5gaUd2HL2mkxoK7+RstkGHS2cnAYjmMbHVN6gao66iaBQ+0gjpT8PmAf75oPksVhFyelpB9ZJFqFnbYxlWa5Siz/p4UF6qYt5rW6Ccyx4g=  ;
X-YMail-OSG: w4O4AMYVM1lBqrW5IS0u5MRGLTflK_4MbbwyxB8BOUbJvslNatHzxM7NGV1UZ_NGoxP.G7DWdLk14Qu4Qz8gdBd5WK79OJRsLgbwqcj_IC.RHI26PwA8abruEpBA5.lvgxVP2CPolIBacMXQpIy1ziy6
X-Yahoo-Newman-Property: ymail-3
Message-ID: <481A670F.1030709@sbcglobal.net>
Date: Thu, 01 May 2008 17:57:51 -0700
From: Ryan Roth <ryanroth@sbcglobal.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting
 With 2.6.24.5 Kernel
References: <bug-10586-10286@http.bugzilla.kernel.org/>	<20080501130444.cc5c63e8.akpm@linux-foundation.org>	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>	<20080501133003.be723364.akpm@linux-foundation.org>	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>	<481A5276.4040607@sbcglobal.net>	<20080501170239.9b740877.akpm@linux-foundation.org>	<481A5A94.2080400@sbcglobal.net> <20080501173408.384b4fc3.akpm@linux-foundation.org>
In-Reply-To: <20080501173408.384b4fc3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 01 May 2008 17:04:36 -0700
> Ryan Roth <ryanroth@sbcglobal.net> wrote:
>
>   
>> Since this last boot I have only got these:
>>
>>     
>>> May 1 16:26:25 kernel: gnome-power-man[3112]: segfault at 0 ip 410fda 
>>> sp 7fff4712c870 error 4 in gnome-power-manager[400000+47000]
>>> May 1 16:26:25 kernel: gnome-power-man[3116]: segfault at 0 ip 410fda 
>>> sp 7fff2959cce0 error 4 in gnome-power-manager[400000+47000]
>>> May 1 16:26:25 kernel: gnome-power-man[3119]: segfault at 0 ip 410fda 
>>> sp 7fffc7671db0 error 4 in gnome-power-manager[400000+47000]
>>>       
>
> OK.
>
> Well I don't know what the heck to do about that.  It could be that we've
> gone and changed the contents of (say) an acpi /proc file, and this happens
> to cause your particular version of gnome-power-manager to take a different
> (and buggy) codepath, so it crashes.  Or something like this.
>
> I hate to do this to you, but our best hope for getting to the bottom of
> this is for you to run a git bisection search to find out what we did which
> triggered this.  http://www.kernel.org/doc/local/git-quick.html has some
> instructions.
>
> Or you could go the other route and work out where and why
> gnome-power-manager is crashing.
>
> You could try upgrading (or downgrading) your gnome-power-manager version,
> see if that affects things.
>
> Does the problem affect only gnome-power-manager?
>
>   

OK it looks like I was possibly (probably) barking up the wrong tree.  I 
was able to get gnome-phone-manager to give me some useful information 
and it turns out that gnome-power-management crashes if 
gnome-phone-manager is running first (which I had set to autorun) 
something to due with bluetooth errors.
