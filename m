Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXFPDU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXFPDU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 23:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbXFPDUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 23:20:48 -0400
Received: from smtpout.mac.com ([17.250.248.186]:58206 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbXFPDUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 23:20:47 -0400
In-Reply-To: <Pine.LNX.4.64.0706152131450.32724@fbirervta.pbzchgretzou.qr>
References: <a800cda90706120545w2c6d0bb0vb77bd4d961415c5c@mail.gmail.com> <75b66ecd0706120744g7cdb3392l6537b5c68c2d6b21@mail.gmail.com> <a800cda90706121325p18c85b00r7bc4b15b95517371@mail.gmail.com> <4672C76D.5050008@cfl.rr.com> <Pine.LNX.4.64.0706152131450.32724@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A9FA6BE4-CB04-4650-B6E0-BCAA6A9F84D8@mac.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, "R.F. Burns" <burnsrf@gmail.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: PC speaker
Date: Fri, 15 Jun 2007 23:20:14 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, at 15:34:52, Jan Engelhardt wrote:
> Perhaps live cd? In which case, the OP should, as recommended in  
> this thread already, deactivate choosing boot devices, if that's  
> possible.
>
> (Unfortunately, newer BIOSes with 'integrated bootmenu' with F8 or  
> so, but I have not seen a way to deactivate _that_ menu.)

Heh, with virtually every PC BIOS I've seen, the procedure is  
something like this:

1)  Reboot into BIOS
2)  Set a BIOS "Supervisor Password" (as opposed to "User" or "Boot"  
password)
3)  Go to the "Boot Devices" list and uncheck everything except "Hard  
Disk"
4)  Go to the "USB Stick Hard Disk Emulation" feature and turn that off
5)  Save settings to BIOS and reboot (Usually "F10" or "ESC-Y" )

The "Integrated BootMenu (F8)" stuff only lists boot devices that are  
enabled in the BIOS.  If everything but the hard disk is disabled  
then pressing (F8) is _really_useful_ :-)
   1) Boot from Hard Disk
   2) Enter BIOS Setup

Of course, choosing option 2 is also quite an entertaining thing for  
the student:
,--------------------------.
| Enter Password: ******** |
`--------------------------'

And since they don't actually know the password, it's followed by the  
inevitable:
,--------------------------.
|     Invalid Password     |
`--------------------------'

Admittedly there are more things to turn off than with older BIOSen,  
but there are also more features too.  Of course, with OpenFirmware- 
based systems (like the PowerPC macs) it's scriptable and doesn't  
require rebooting.
   1)  Install the "nvsetenv" utility via your distro

   2)  Encode your password by xoring each character's ascii value  
with 0xAA and printing the result in hex.  This perl oneliner will do  
it easily (Change 'my-password' to your plain-text password).
     perl -ne 'map { printf "%%%02x", 0xaa ^ ord($_) } split //, $1;  
print "\n"' my-password

   For example, the password "linux" is encoded as "%c6%c3%c4%df%d2"

   3)  Run "nvsetenv security-password %c6%c3%c4%df%d2", where the  
hex stuff is your encoded password

   4)  Run "nvsetenv security-mode command"

Then it auto-locks all possible ways of modifying the open-firmware  
boot device or specifying alternative boot options.  The only way to  
get around it on most systems is with the firmware-reset button on  
the inside of the case or moving RAM around and rebooting with some  
magic key combo held down (Cmd-Opt-P-R on mac systems).  Typically if  
your students can do that there's exactly nothing you can do to  
prevent them from doing whatever they want.  They could always just  
stick in a different hard-drive, after all.

Cheers,
Kyle Moffett

