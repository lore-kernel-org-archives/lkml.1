Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYH2Rny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYH2Rny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYH2Rnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:43:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:64768 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbYH2Rno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FsptWLLS7pETY8ognrWp8W3A513Ss0+Mgx0OhZyb8EsQfXVE1o5qyha/yaw2GHE4op
         WR1AC7W5YtqBZveO8haAY66YRi2R6aHjGRBhPuwI4liRJ+a6T+mJfcbJrc5VOfay02++
         jx9l3Z7wvcdmrPmFJcVDPGZa8PQ7NJ4nl1h3U=
Message-ID: <86802c440808291043s774d3913k85de758f2e23b24b@mail.gmail.com>
Date: Fri, 29 Aug 2008 10:43:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexander Huemer" <alexander.huemer@sbg.ac.at>
Subject: Re: 2.6.27 mtrr fixes do not work
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Helge Hafting" <helge.hafting@aitel.hist.no>
In-Reply-To: <48B81138.4060601@sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at>
	 <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>
	 <48B313C3.30704@sbg.ac.at>
	 <86802c440808251322l72546d59o90c4e0b87c81538c@mail.gmail.com>
	 <48B31508.6020305@sbg.ac.at>
	 <86802c440808251344h697a27d0i91486a836d258cb@mail.gmail.com>
	 <86802c440808251624u181a98eesd8a19ea6fd3d8d8c@mail.gmail.com>
	 <48B34056.5080100@sbg.ac.at>
	 <86802c440808251633s7bf8ecb2ua6ef187b5be563db@mail.gmail.com>
	 <48B81138.4060601@sbg.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 8:09 AM, Alexander Huemer
<alexander.huemer@sbg.ac.at> wrote:
> Yinghai Lu wrote:
>> On Mon, Aug 25, 2008 at 4:29 PM, Alexander Huemer
>> <alexander.huemer@sbg.ac.at> wrote:
>>> Yinghai Lu wrote:
>>>> On Mon, Aug 25, 2008 at 1:44 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>>
>>>>> On Mon, Aug 25, 2008 at 1:24 PM, Alexander Huemer
>>>>> <alexander.huemer@sbg.ac.at> wrote:
>>>>>
>>>>>
>>>>>> what do you mean with tip/master?
>>>>>>
>>>>> http://people.redhat.com/mingo/tip.git/readme.txt
>>>>>
>>>>>
>>>>>> here is my .config: http://xx.vu/~ahuemer/config.txt
>>>>>>
>>>> using your config, i do get mtrr cleanup
>>>>
>>> very interesting, thx.
>>> so, what can i do to make it working here?
>>> are there some more debug options i could turn on?
>>>
>>
>> can you post whole boot log with command line
>>
>> console=uart8250,io,0x3f8,115200n8 debug show_msr=1
>>
>> assume you have serial console...
>>
>> YH
> yinghai,
>
> there are quite good news! 2.6.27-rc5 brought some significant changes.
> now i get this:
>
>    # dmesg|grep -E "(mtrr|uvesafb)"
>    Command line: root=/dev/sda1 video=uvesafb:1280x1024p-97,mtrr:2
>    debug show_msr=1
>    mtrr: your BIOS has set up an incorrect mask, fixing it up.
>    Kernel command line: root=/dev/sda1
>    video=uvesafb:1280x1024p-97,mtrr:2 debug show_msr=1
>    uvesafb: XGI Technology, Inc., Volari Z9s, 1.09.10, OEM: XGI, VBE v3.0
>    uvesafb: VBIOS/hardware supports DDC2 transfers
>    uvesafb: monitor limits: vf = 97 Hz, hf = 129 kHz, clk = 364 MHz
>    uvesafb: scrolling: redraw
>    uvesafb: framebuffer at 0xd8000000, mapped to 0xffffc20002100000,
>    using 10240k, total 32768k
>    mtrr: 0xd8000000,0x2000000 overlaps existing 0xd8000000,0x800000
>    # grep -E "(^\(WW\)|^\(EE\)|^\(NI\)|^\(??\))" /var/log/Xorg.0.log
>    (WW) VESA(0): Failed to set up write-combining range
>    (0xd8000000,0x2000000)
>    # cat /proc/mtrr
>    reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>    reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>    reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>    reg03: base=0xd8000000 (3456MB), size=   8MB: write-back, count=1

it seems BIOS setup extra entry (8M) and that is conflict with that of
from graphical card.

can you send out
dmesg -s 262144 > dmesg.txt
and
lspci -vvxxx
lspci -tv

so could find out if your graphical card is really allocated the memory area...

YH
