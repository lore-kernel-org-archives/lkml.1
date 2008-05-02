Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbYEBBse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbYEBBse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYEBBsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:48:24 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:43571 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752029AbYEBBsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:48:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=YfnRyaFVEqMcheVuMFrXpkvmDopxtRPE9wJiBMKR6kLziMBmO3dDXcEvQgtCoJ6mrm/Xh8g35MUDxvVV9HJ3gzV5I367TnmX0wSJYRMj6iUlpKN4VVHbl7aWF01SzVg+XuUZUEGFd+6QDRbMkJr97E/jU8lJrdAtCF5MMcN7+yQ=  ;
X-YMail-OSG: 3MuskLUVM1lpR_XFuxShYzCLqS7uT9HBhPHNTwSgK4Vn1m89RBEaafI.23bduo.NBnCUQWh1zN7swdcZU1pqJ_jzVOFWrVp9RwkquOA031M12wb9RRd2aVZFdb560RsYkCwASITJEK51JythkVvc_VXh
X-Yahoo-Newman-Property: ymail-3
Message-ID: <481A7297.9010002@sbcglobal.net>
Date: Thu, 01 May 2008 18:47:03 -0700
From: Ryan Roth <ryanroth@sbcglobal.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting
 With 2.6.24.5 Kernel
References: <bug-10586-10286@http.bugzilla.kernel.org/>	<20080501130444.cc5c63e8.akpm@linux-foundation.org>	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>	<20080501133003.be723364.akpm@linux-foundation.org>	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>	<481A5276.4040607@sbcglobal.net>	<20080501170239.9b740877.akpm@linux-foundation.org>	<481A5A94.2080400@sbcglobal.net>	<20080501173408.384b4fc3.akpm@linux-foundation.org>	<481A670F.1030709@sbcglobal.net> <20080501184212.f0a685cd.akpm@linux-foundation.org>
In-Reply-To: <20080501184212.f0a685cd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 01 May 2008 17:57:51 -0700 Ryan Roth <ryanroth@sbcglobal.net> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> On Thu, 01 May 2008 17:04:36 -0700
>>> Ryan Roth <ryanroth@sbcglobal.net> wrote:
>>>
>>>   
>>>       
>>>> Since this last boot I have only got these:
>>>>
>>>>     
>>>>         
>>>>> May 1 16:26:25 kernel: gnome-power-man[3112]: segfault at 0 ip 410fda 
>>>>> sp 7fff4712c870 error 4 in gnome-power-manager[400000+47000]
>>>>> May 1 16:26:25 kernel: gnome-power-man[3116]: segfault at 0 ip 410fda 
>>>>> sp 7fff2959cce0 error 4 in gnome-power-manager[400000+47000]
>>>>> May 1 16:26:25 kernel: gnome-power-man[3119]: segfault at 0 ip 410fda 
>>>>> sp 7fffc7671db0 error 4 in gnome-power-manager[400000+47000]
>>>>>       
>>>>>           
>>> OK.
>>>
>>> Well I don't know what the heck to do about that.  It could be that we've
>>> gone and changed the contents of (say) an acpi /proc file, and this happens
>>> to cause your particular version of gnome-power-manager to take a different
>>> (and buggy) codepath, so it crashes.  Or something like this.
>>>
>>> I hate to do this to you, but our best hope for getting to the bottom of
>>> this is for you to run a git bisection search to find out what we did which
>>> triggered this.  http://www.kernel.org/doc/local/git-quick.html has some
>>> instructions.
>>>
>>> Or you could go the other route and work out where and why
>>> gnome-power-manager is crashing.
>>>
>>> You could try upgrading (or downgrading) your gnome-power-manager version,
>>> see if that affects things.
>>>
>>> Does the problem affect only gnome-power-manager?
>>>
>>>   
>>>       
>> OK it looks like I was possibly (probably) barking up the wrong tree.  I 
>> was able to get gnome-phone-manager to give me some useful information 
>> and it turns out that gnome-power-management crashes if 
>> gnome-phone-manager is running first (which I had set to autorun) 
>>     
>
> heh, thanks, I wish they were all that simple.
>
> It'd be useful to go back to 2.6.24 and check that the same effects are
> seen there with the same userspace setup.
>
>   
>> something to due with bluetooth errors.
>>     
>
> Well..  bluetooth isn't exactly our shining example of kernel technology
> I'm afraid.  If you do suspect there are kernel problems in there please be
> sure to cc linux-bluetooth@vger.kernel.org on the email.
>
>
>   
I'm pretty sure it's an issue with bluez, thanks for all help.
