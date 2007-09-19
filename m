Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbXISFRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbXISFRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXISFRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:17:13 -0400
Received: from smtpoutm.mac.com ([17.148.16.71]:58828 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbXISFRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:17:12 -0400
In-Reply-To: <alpine.LFD.0.999.0709190503250.26241@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in> <20070906150616.GA28565@fieldses.org> <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com> <1189121714.6672.38.camel@heimdal.trondhjem.org> <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com> <alpine.LFD.0.999.0709190503250.26241@enigma.security.iitk.ac.in>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A5318C25-7864-453A-B09A-00232D9EAF2A@mac.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: NFS4 authentification / fsuid
Date: Wed, 19 Sep 2007 01:16:28 -0400
To: Satyam Sharma <satyam@infradead.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 18, 2007, at 19:44:59, Satyam Sharma wrote:
> On Thu, 6 Sep 2007, Kyle Moffett wrote:
>> On Sep 06, 2007, at 19:35:14, Trond Myklebust wrote:
>>> On Thu, 2007-09-06 at 19:30 -0400, Kyle Moffett wrote:
>>>> On Sep 06, 2007, at 11:06:16, J. Bruce Fields wrote:
>>>>> The question of how to protect against someone with *physical*  
>>>>> access certainly is more difficult, but surely that's a  
>>>>> separate problem.
>>>>
>>>> Actually, that's a fairly simple problem (barring disassembling  
>>>> the system and attaching a hardware debugger).  You encrypt the  
>>>> root filesystem and  require a password to boot (See: LUKS).   
>>>> Debian has built-in support for installing onto fs-on-LVM-on- 
>>>> crypt-on-RAID, and it works quite well on all the laptops I use  
>>>> regularly.  It's not even much of a speed penalty; once you take  
>>>> the overhead of hitting a 5400RPM laptop drive you can chew  
>>>> thousands of cycles of CPU without anybody noticing (much).   
>>>> Then all you have to do is burn a copy of your /boot with  
>>>> bootloader onto some read-only media (like a finalized CDROM/ 
>>>> DVDROM) and you're set to go.
>>>
>>> Disconnect battery, and watch boot password go 'poof!'.
>>
>> Umm, I did say "encrypt the root filesystem", didn't I?  Booting  
>> my laptops
>
> The whole *point* here is to secure against physical access -- then  
> how can you assume "barring disassembling the system"? If you're  
> not considering attacks such as those, then how _are_ you solving  
> the physical access problem in the first place? :-)

Security is about fractional reduction of risk, and anybody who tells  
you otherwise is either ignorant or lying through their teeth.  There  
are *multiple* aspects of "physical access"; one of those is access  
while the box is off and no data resident in volatile memory, which  
is the easy case.  Basically there you can just encrypt the non- 
volatile storage.  If the system is *on* and has unencrypted data in  
memory (such as suspend-to-RAM for example) then you *HAVE* to ensure  
that it can't be easily disassembled and a hardware debugger  
attached; there is no way around that very fundamental limitation.

Basically if the key is resident and unencrypted as is necessary to  
*USE* the system, then no amount of hardware is going to *prevent* a  
dedicated attacker from getting at it unless you make it so  
unportable that you don't have to worry about somebody carrying it  
off in the first place.  Typical mechanisms to increase the time and  
effort to break into a device include wiring the entire enclosure  
with extremely thin filament wires and detecting automatically wiping  
the system upon any variation in a small flow of current through said  
filament.

>> this way follows this procedure:
>>  1) Enter BIOS boot menu
>>  2) Insert /boot CDROM
>>  3) Select the "CDROM" entry
>>  4) Wait for kernel to start and run through initramfs
>>  5) Type password into the initramfs prompt so that it can DECRYPT  
>> THE ROOT FILESYSTEM
>>  6) Continue to boot the system.
>>
>> Under this setup, tinkering with my BIOS does virtually nothing;  
>> the only avenues of attack are strictly of the "Install a hardware  
>> keylogger" variety.
>
> Doesn't flashing/replacing your BIOS firmware/chip count as  
> tinkering?  Then I don't really need a "hardware keylogger", do I ...

Ok, so you are saying your plan of attack on this system would be:
   1)  Steal the laptop such that I don't notice it has been stolen
   2)  Open it up
   3)  Replace the very-vendor-specific BIOS chip with a reflashed  
one with sufficient storage to do all the things the old BIOS could  
*AND* have enough storage for an entire replacement kernel binary  
with a built-in keylogger, as well as some storage for the logged  
password
   4)  Return the laptop, again such that I don't notice it has been  
missing
   5)  Wait for me to boot and type my password
   6)  Somehow recover the laptop *yet* *again* to get the password  
back off of it and decrypt the disk

Yes it "can be done", but so can dumping the firmware for an iPod out  
through the built-in piezo clicker[1].  USE SOME COMMON SENSE HERE  
PEOPLE!!!  The only "unbreakable" computer is one always disconnected  
and off under armed guard in a bank vault, and even then it's only as  
secure as the bank in which it is stored (which get broken into on  
occasion).

I am assuming that if the laptop has sufficiently important data on  
it to warrant the above steps then I am also clueful enough to:
   (A)  Not carry the laptop around unsecured areas,
   (B)  Keep a close enough eye on it and be aware that it's gone by  
the time they get to step 2, OR
   (C)  Pay somebody to build me a better physical chassis for my laptop

We are talking about *STANDARD* laptop systems with reasonably alert  
users.  If the user doesn't know how to properly protect the stuff on  
the laptop then they probably don't know how to properly protect the  
other copy in their heads, either.  Besides, if some government  
wanted the data on your laptop that bad they'd just pick you up in  
the middle of the night and torture your password out of you.

On Sep 18, 2007, at 19:48:16, Satyam Sharma wrote:
> On Fri, 7 Sep 2007, Kyle Moffett wrote:
>> So you can't draw any relationships between "Protect the end-user"  
>> with "Protect the device FROM the end-user", the former can be  
>> done very reliably to whatever level of risk-reduction you need  
>> and the latter can't practically be done at all.
>
> Well, you're the one who called solving the physical access problem  
> "easy" here ... :-)

If your system equates end-user with attacker then you are *screwed*  
regardless!  If you give the end-user the tools that they need to use  
the system, then they can just as easily hack into it, *END* *OF*  
*STORY*.  See   The _only_ way to protect data on a piece of hardware  
is with the _assistance_ of the end-user; they have to be alert and  
aware of potential threats and act to protect from them.

Cheers,
Kyle Moffett

[1] http://hardware.slashdot.org/article.pl?sid=05/01/29/2017244
