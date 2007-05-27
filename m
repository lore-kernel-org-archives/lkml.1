Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbXE0NgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbXE0NgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 09:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXE0NgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 09:36:01 -0400
Received: from smtpout.mac.com ([17.250.248.184]:60381 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbXE0NgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 09:36:00 -0400
In-Reply-To: <9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com> <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com> <9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4F828E03-DA6B-484E-A8F2-885D1BC6F23E@mac.com>
Cc: James Morris <jmorris@namei.org>, casey@schaufler-ca.com,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sun, 27 May 2007 09:35:35 -0400
To: Toshiharu Harada <haradats@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 27, 2007, at 03:25:27, Toshiharu Harada wrote:
> 2007/5/27, Kyle Moffett <mrmacman_g4@mac.com>:
>> On May 26, 2007, at 19:08:56, Toshiharu Harada wrote:
>>> 2007/5/27, James Morris <jmorris@namei.org>:
>>>> On Sat, 26 May 2007, Kyle Moffett wrote:
>>>>> AppArmor).  On the other hand, if you actually want to protect  
>>>>> the _data_, then tagging the _name_ is flawed; tag the *DATA*  
>>>>> instead.
>>>>
>>>> Bingo.
>>>>
>>>> (This is how traditional Unix DAC has always functioned, and is  
>>>> what SELinux does: object labeling).
>>>
>>> Object labeling (or labeled security) looks simple and straight  
>>> forward way, but it's not.
>>>
>>> (1) Object labeling has a assumption that labels are always  
>>> properly defined and maintained. This can not be easily achieved.
>>
>> That's a circular argument, and a fairly trivial one at that.
>
> Sorry Kyle, I don't think it's a trivial one.  The opposite.

How is that argument not trivially circular?  "Foo has an assumption  
that foo-property is always properly defined and maintained."  That  
could be said about *anything*:
   *  Unix permissions have an assumption that mode bits are always  
properly defined and maintained
   *  Apache .htaccess security has an assumtion that .htaccess files  
are always properly defined and maintained.
   *  Functional email communication has an assumption that the email  
servers are always properly defined and maintained

>> If you can't properly manage your labels, then how do you expect  
>> any security at all?
>
> Please read my message again. I didn't say, "This can never be  
> achieved".  I said, "This can not be easily achieved".

So you said "(data labels) can not be easily achieved".  My question  
for you is: How do you manage secure UNIX systems without standard  
UNIX permission bits?  Also:  If you have problems with data labels  
then what makes pathname based labels "easier"?  If there is  
something that could be done to improve SELinux and make it more  
readily configurable then it should probably be done.

>> If you can't achieve the first with reasonable security, then you  
>> probably can't achieve the second either.  Also, if you can't  
>> manage correct object labeling then I'm very interested in how you  
>> are maintaining secure Linux systems without standard DAC.
>
> I'm very interested in how you can know that you have the correct  
> object labeling (this is my point). Could you tell?

I know that I have the correct object labeling because:
   1) I rewrote/modified the default policy to be extremely strict on  
the system where I wanted the extra security and hassle.
   2) I ensured that the type transitions were in place for almost  
everything that needed to be done to administer the system.
   3) I wrote a file-contexts file and relabeled *once*
   4) I loaded the customized policy plus policy for restorecon and  
relabeled for the last time
   5) I reloaded the customized policy without restorecon privileges  
and without the ability to reload the policy again.
   6) I never reboot the system without enforcing mode.
   7) If there are unexpected errors or files have incorrect labels,  
I have to get the security auditor to log in on the affected system  
and relabel the problematic files manually (rare occurrence which  
requires excessive amounts of paperwork).

>>> (2) Also, assigning a label is something like inventing and  
>>> assigning a *new* name (label name) to objects which can cause  
>>> flaws.
>>
>> I don't understand how assigning new attributes to objects "can  
>> cause flaws", nor what flaws those might be; could you elaborate  
>> further? In particular, I don't see how this is really all that  
>> more complicated than defining additional access control in  
>> apache .htaccess files.  The principle is the same:  by stacking  
>> multiple independent security-verification mechanisms (Classical  
>> UNIX DAC and Apache permissions) you can increase security, albeit  
>> at an increased management cost.  You might also note that  
>> ".htaccess" files are yet another form of successful "label-based"  
>> security; the security context for a directory depends on  
>> the .htaccess "label" file found within.  The *exact* same  
>> principles apply to SELinux: you add additional attributes backed  
>> by a simple and powerful state-machine.  The cross-checks are  
>> lower-level than those from .htaccess files, but the principles  
>> are the same.
>
> I don't deny DAC at all.  If we deny DAC, we can't live with Linux  
> it's the base.  MAC can be used to cover the shortages of DAC and  
> Linux's simple user model, that's it.
>
> From security point of view, simplicity is always the virtue and  
> the way to go.  Inode combined label is guaranteed to be a single  
> at any point time.  This is the most noticeable advantage of label- 
> based security.

I would argue that pathname-based security breaks the "simplicity is  
the best virtue (of a security system)" paradigm, because it  
attributes multiple potentially-conflicting labels to the same piece  
of data.  It also cannot protect the secrecy of specific *data* as  
well as SELinux can.  For example:  In SELinux MLS a system could  
mark customer credit-card data as the "cust_private_info" category  
and it would be completely impossible for any program without the  
"cust_private_info" category to read that data, and even then it  
could only be written to files which also have "cust_private_info"  
set.  While a few privileged programs may have "mlsread" or  
"mlswrite" attributes allowing them to override such restrictions,  
it's a much stronger security guarantee than pathname-based security  
could ever provide.

> But writing policy with labels are somewhat indirect way (I mean,  
> we need "ls -Z" or "ps -Z").  Indirect way can cause flaw so we  
> need a lot of work that is what I wanted to tell.

I don't really use "ls -Z" or "ps -Z" when writing SELinux policy; I  
do that only when I actually think I mislabeled files.  Typically the  
SELinux-policy-development cycle is:
   1)  Modify and reload the policy
   2)  Relabel the affected files (either by hand or with some  
automated tool like restorecon)
   3)  Rerun the problem program or daemon
   4)  Examine the errors in the audit logs.  If there are no errors  
and it works then you're finished.
   5)  Go back to step 1 and fix your policy

Cheers,
Kyle Moffett

