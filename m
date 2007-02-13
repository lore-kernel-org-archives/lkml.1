Return-Path: <linux-kernel-owner+w=401wt.eu-S1750993AbXBMUT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbXBMUT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXBMUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:19:56 -0500
Received: from smtpout05-04.prod.mesa1.secureserver.net ([64.202.165.221]:46255
	"HELO smtpout05-04.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751004AbXBMUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:19:55 -0500
Message-ID: <45D21D71.2000708@techmoninc.com>
Date: Tue, 13 Feb 2007 14:20:01 -0600
From: Andy Kennedy <akennedy@techmoninc.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Serial console issues.
References: <45D0D09D.8010807@techmoninc.com> <Pine.LNX.4.63.0702121255100.6630@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0702121255100.6630@qynat.qvtvafvgr.pbz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang wrote:
> On Mon, 12 Feb 2007, Andy Kennedy wrote:
>
>>
>> For those of you who are on BusyBox's mailing list, you've already 
>> seen this -- I was sent here for help.
>>
>> Specs:
>> Linux:  2.6.18
>> Bootloader:  SysLinux
>> Init:  BusyBox (ver 1.4.0) init.
>> Kernel command line: console=ttyS0,115200,n,8,1
>> System: VersaLogic 568 (STD80/STD32 Bus, i386 based computer)
>> Issue:  Booting on "System" I get perfect printk's to the serial 
>> console. When the init takes over (from within an initrd), the 
>> console begins to miss characters.  I can still send write commands 
>> through the console, however, the output of these commands is 
>> garbled.  The really odd part is when the init releases control (is 
>> killed by Linux), or when a printk is issued, the console prints 
>> perfectly again.  The next really strange part about this is that 
>> changing "System" to my laptop -- no problems PERIOD. The BusyBox 
>> list directed me to LKML as this is a wider base of users that may 
>> have experienced the same problem and could provide me an answer.
>
> I've seen this happen when you accidently have multple programs 
> attached to the same console (even with the text-mode vga consoles)
>
> double check that nothing else is trying to use that serial port
>
> David Lang
>
<Adding Off-line chatter Between David Lang and Andy Kennedy>
>>>> Not to be thick, but it is the same disk used on two different 
>>>> systems. . . one works, the other doesn't.  Doesn't that imply that 
>>>> there is only one thing grabbing the serial port?  If not, I'll 
>>>> look again.  I have even had this problem with nothing in the 
>>>> inittab. . . The only thing I could think is that maybe something 
>>>> within the init code opens the /dev/console the wrong way. . . or 
>>>> is init opening /dev/console AND /dev/ttyS0 and that is what is 
>>>> causing the problem????  BUT, then why would it work on my laptop, 
>>>> however, not the embedded system?
>>>
>>> with the same disk working differently on different hardware I would 
>>> start looking at the drivers and interrupts. does one of the two 
>>> have different hardware that could be shareing an interrupt and the 
>>> other doesn't?
>>>
>>> David Lang
>> Other than looking into proc, is there another way to determine 
>> this?  The BIOS CMOS setup isn't that forthcoming with any 
>> information -- this is an older board and has very limited settings 
>> on it.
>>
>> In proc/interrupts I'm seeing nothing but serial on 4.
>>
>> Do you know if the kernel preforms any type of init on the 
>> /dev/console before it writes each time?  IE, from the BusyBox code, 
>> I cannot see that it mucks with the /dev/console before it writes, 
>> but the code is so thick I may have missed something.
>
> I don't know the answers to these questions, sorry. I'm not a kernel 
> hacker, just an experianced user, and since this problem sounded 
> familiar I spoke up. at this point we are getting out of my depth.
>
> David Lang
Me neither David. . . but thanks for you help.

Another piece of the puzzle (sorry I left this off before, didn't think):
SERIAL PORT TYPE:  TI16750

In printk(), when something is sent from the kernel to the console, is 
there an initialization that occurs prior to the actual write to the 
console?  How does the console interact with ttyS0 when console=ttyS0 is 
supplied as command line parameter?  When an init interfaces the 
console, should it also send the setup information if it detects that 
console=<serial device>?  OR. . . could there be something specific to 
this hardware that requires additional coding to get the console to work 
the correct way (i.e. some form of force send, etc)?

Before, I explained how the printk comes out perfectly, then BusyBox 
hoses the connection, then another printk will reset the input.  The 
following is a snippet of that:
> Using IPI Shortcut mode
> drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> Time: pit clocksource has been installed.
> Freeing unused kernel memory: 536k freed
>  :l
>    a l
>       tr'
>          z ye
>               .
>                gg et dil
>                         t'
>
>
>
>
>
> g input: AT Translated Set 2 keyboard as /class/input/input0
>
I'm in way over my head on this one since I don't know the underling 
driver for the serial port on Linux. Sorry again for polluting your list 
and thanks in advance (again) for any assistance you can provide me on 
this issue.

Andy Kennedy
