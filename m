Return-Path: <linux-kernel-owner+w=401wt.eu-S1163316AbXD1Rzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163316AbXD1Rzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163315AbXD1RxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:24 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:11931 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163307AbXD1Rwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ex/Yk50GRChJjz+I4FGzUtDAuC34CgJz201t7d75LTVDobz1J6+MeSu/dVV83JbcomoMOrDHB5e7CNfBaKGs12jcbiP+fi618DP4XBtFKy1ecN8C8NAGD5Z+KKzXSoShlxIeddBq76HMaDCnqv0Efia9I0ftA6MJ/ke3VcXfI6w=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
Date: Sat, 28 Apr 2007 13:52:44 -0400
User-Agent: KMail/1.9.6
Cc: stable@kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, "Riccardo Ricci" <rricci@nuovanetmore.it>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       "Len Brown" <len.brown@intel.com>,
       "David Brownell" <david-b@pacbell.net>, "Jeff Mahoney" <jeffm@suse.com>,
       reiserfs-dev@namesys.com, "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Francois SIMOND" <curio@free.fr>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org,
       "=?iso-8859-1?q?H=E5kan?= Lindqvist" <lindqvist@netstar.se>,
       "Vincent Frentzel" <zcecc22@ucl.ac.uk>,
       "=?iso-8859-1?q?Fran=E7ois?= Valenduc" <francois.valenduc@skynet.be>,
       "Thomas Meyer" <thomas.mey@web.de>,
       "Giorgio Lando" <patroclo7@gmail.com>, "Dave Jones" <davej@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <463375E5.5040108@googlemail.com> <200704281252.20381.gene.heskett@gmail.com> <6bffcb0e0704281018h68a6d63fw8747b63bc1b86a4b@mail.gmail.com>
In-Reply-To: <6bffcb0e0704281018h68a6d63fw8747b63bc1b86a4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281352.44784.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 April 2007, Michal Piotrowski wrote:
>Hi Gene,
>
>On 28/04/07, Gene Heskett <gene.heskett@gmail.com> wrote:
>> On Saturday 28 April 2007, Michal Piotrowski wrote:
>> >Hi all,
>> >
>> >Here is a list of known regressions reported after 2.6.21 release.
>> >
>> >Feel free to add new regressions/remove fixed etc.
>> >http://kernelnewbies.org/known_regressions
>>
>> I went here, but without a login the page is immutable
>>
>> Therefore I'll add it here
>>
>> Subject         :proprietary belkin upsd turns into cpu hog
>
>I'm not sure if I understand correctly. Is it a proprietary driver?
>If so, it's not a task for -stable team.
>
>> Submitter       :gene.heskett@gmail.com
>> Reference       :something changed in how /dev/ttyUSB's handle 1 and 2
>> byte messages from pl2303 usb<->serial adaptors.  Also, assignation of
>> ttyUSB#'s is volatile depending on phase of the moon when booted.
>
>Regards,
>Michal

I'm not sure if my use of that should be dismissed out of hand because its 
proprietary, the point being that the pl2303 driver seems to have 
deteriorated over the last month or so to the point that now neither of my 
pl2303 cables is working, while the FTDI adaptor I put in the heyu path a 
month ago is working just fine.  I do have another FTDI cable too, but I need 
to get an extension for it, 10" overall just won't reach the ups so its not 
yet tested. 

Up until this boot to 2.6.21-cfs-v7, I could usually make that proprietary 
upsd driver daemon work if I killed it, reconfigured it to use whatever port 
it got at this bootup, kill it, restart it etc and eventually it would settle 
down to 0.0% cpu, and work fine.  Today I had to swap ports in both its 
config and in heyu's after the reboot.  heyu is fine now, but the pl2303 is 
totally, can't even cat the 1 or 2 bytes a second worth of data that should 
be coming from it, dead.

Hence, I'm pointing my personal finger of blame at the pl2303 driver, which 
I've noted has been touched a couple of times recently.

In this case, no other change in the kernel config, just swapped the sd046 
patch for the cfs-v7 patch, installed and rebooted.

I started having trouble with this in the middle (roughly) of the 2.6.21-rc 
series.
-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Universe, n.:
	The problem.
