Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbXKQNg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbXKQNg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 08:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbXKQNgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 08:36:47 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:55534 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbXKQNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 08:36:46 -0500
Message-ID: <473EEEC7.1070300@abinetworks.biz>
Date: Sat, 17 Nov 2007 14:38:15 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: markus reichelt <ml@mareichelt.de>, linux-kernel@vger.kernel.org
Subject: Re: NFS Bug in 2.6.23 ?
References: <473D6B5C.4090701@abinetworks.biz>	 <20071116121148.GI4290@tatooine.rebelbase.local> <1195222863.7653.18.camel@heimdal.trondhjem.org>
In-Reply-To: <1195222863.7653.18.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have made couple of tests:

1) (The fast one) Checked out, even if .config was the same onto both 
kernels, DIRECTIO: it was not set on both kernel configs.
2.6.20 works fine, .23 not.
This somehow seems to agree with Trond's P.O.V.
Finally i am wondering why should we set DIRECTIO to fix things on 
2.6.23 (supposed that it worked, i will try) when this could lead to 
inefficiencies, especialli where (CFSD) we need performance.
So far my opinion is that we should investigate deeper and find whats 
the problem.

2) (The verbose one) tcpdumped loopback iface onto my server (cfs is a 
loopback extended nfs server). For the test i set up an encrypted dir in 
which i put some webfiles and tested both listing the directory and 
accessing files in it by a remote mozilla setting httpd's DocumentRoot 
on /opt/clear/www. Got some output, here i go:

tcpdump -vv -i lo -s 9000
tcpdump: listening on lo, link-type EN10MB (Ethernet), capture size 9000 
bytes
[...]

Now i ls /opt/clear/www

17:12:07.150036 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum f303!] UDP, 
length: 116
17:12:07.150301 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum 47c5!] UDP, length: 96
17:12:13.405741 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum 7b69!] UDP, 
length: 116
17:12:13.405790 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum f6de!] UDP, length: 96
17:12:13.405814 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum 7b68!] UDP, 
length: 116
17:12:13.405827 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum f6dd!] UDP, length: 96
17:12:20.787680 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum 7467!] UDP, 
length: 116
17:12:20.787727 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum f6dc!] UDP, length: 96
17:12:27.076069 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum 6e66!] UDP, 
length: 116
17:12:27.076114 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum f6db!] UDP, length: 96
17:12:38.936258 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum 6265!] UDP, 
length: 116
17:12:38.936415 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum f6da!] UDP, length: 96

it worked, now i fetch a webpage from mozilla on the crypto FS....

17:13:20.226643 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum a8fd!] UDP, 
length: 116
17:13:20.226719 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum 47bf!] UDP, length: 96
17:13:20.226745 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum 3863!] UDP, 
length: 116
17:13:20.226767 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum f6d8!] UDP, length: 96
17:13:20.226990 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum f5f1!] UDP, 
length: 116
17:13:20.227009 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum 4664!] UDP, length: 96
17:13:20.227352 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.675 > debian.3049: [bad udp cksum f5f0!] UDP, 
length: 116
17:13:20.227388 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.675: [bad udp cksum 4663!] UDP, length: 96

...it worked....now ls again (port 917 instead of 675 ?)

18:15:38.567669 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum a7ee!] UDP, 
length: 116
18:15:38.567907 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum a9cd!] UDP, length: 96

this last worked...and finally it breaks (after an hour), couple of ls 
/opt/clear/www and Mozilla Reloads:

10:45:43.231051 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 152) debian.917 > debian.3049: [bad udp cksum 3fc4!] UDP, 
length: 124
10:45:43.231094 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 156) debian.3049 > debian.917: [bad udp cksum c483!] UDP, 
length: 128
10:45:43.231132 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d4c!] UDP, 
length: 116
10:45:43.231141 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cdf1!] UDP, length: 48
10:45:43.231163 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 9d4b!] UDP, 
length: 116
10:45:43.231175 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum a912!] UDP, length: 96
10:45:43.231185 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d4a!] UDP, 
length: 116
10:45:43.231193 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cdef!] UDP, length: 48
10:45:43.231258 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 152) debian.917 > debian.3049: [bad udp cksum 3fc0!] UDP, 
length: 124
10:45:43.231273 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 156) debian.3049 > debian.917: [bad udp cksum c47f!] UDP, 
length: 128
10:45:43.231289 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d48!] UDP, 
length: 116
10:45:43.231297 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cded!] UDP, length: 48
10:45:43.231310 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 9d47!] UDP, 
length: 116
10:45:43.231323 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum a90e!] UDP, length: 96
10:45:43.231333 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d46!] UDP, 
length: 116
10:45:43.231341 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cdeb!] UDP, length: 48
10:45:43.231355 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 152) debian.917 > debian.3049: [bad udp cksum 3fbc!] UDP, 
length: 124
10:45:43.231367 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 156) debian.3049 > debian.917: [bad udp cksum c47b!] UDP, 
length: 128
10:45:43.231382 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d44!] UDP, 
length: 116
10:45:43.231390 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cde9!] UDP, length: 48
10:45:43.231414 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 9d43!] UDP, 
length: 116
10:45:43.231425 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum a90a!] UDP, length: 96
10:45:43.231435 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d42!] UDP, 
length: 116
10:45:43.231443 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cde7!] UDP, length: 48
10:45:43.231490 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 152) debian.917 > debian.3049: [bad udp cksum 3fb8!] UDP, 
length: 124
10:45:43.231503 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 156) debian.3049 > debian.917: [bad udp cksum c477!] UDP, 
length: 128
10:45:43.231519 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d40!] UDP, 
length: 116
10:45:43.231527 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cde5!] UDP, length: 48
10:45:43.231541 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 9d3f!] UDP, 
length: 116
10:45:43.231552 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum a906!] UDP, length: 96
10:45:43.231562 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d3e!] UDP, 
length: 116
10:45:43.231570 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cde3!] UDP, length: 48
10:45:43.231584 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 152) debian.917 > debian.3049: [bad udp cksum 3fb4!] UDP, 
length: 124
10:45:43.231596 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 156) debian.3049 > debian.917: [bad udp cksum c473!] UDP, 
length: 128
10:45:43.231611 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d3c!] UDP, 
length: 116
10:45:43.231618 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cde1!] UDP, length: 48
10:45:43.231632 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 9d3b!] UDP, 
length: 116
10:45:43.231643 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum a902!] UDP, length: 96
10:45:43.231654 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 8d3a!] UDP, 
length: 116
10:45:43.231661 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 76) debian.3049 > debian.917: [bad udp cksum cddf!] UDP, length: 48
10:46:29.073400 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum a79e!] UDP, 
length: 116
10:46:29.073433 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum 31d4!] UDP, length: 96

Trying to ls /opt/cle[TAB] (command completion) lists /opt/clear in 
which cattached dirs live, this refreshed and everything goes up again:

ls /opt/clear/www

10:54:57.359421 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum ab95!] UDP, 
length: 116
10:54:57.359458 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum 31cd!] UDP, length: 96
10:54:57.359616 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 732f!] UDP, 
length: 116
10:54:57.359637 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum 9a0f!] UDP, length: 96
10:54:57.359721 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 732e!] UDP, 
length: 116
10:54:57.359735 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum 9a0e!] UDP, length: 96
10:54:57.360367 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 144) debian.917 > debian.3049: [bad udp cksum 732d!] UDP, 
length: 116
10:54:57.360396 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], 
length: 124) debian.3049 > debian.917: [bad udp cksum 9a0d!] UDP, length: 96

**************************************************************

Thats all, i noticed:
- bad checksums (always, working or not)
- Port changes (portmapper ?)
- Packet length variations: sometimes an ls  takes 2 packs, sometimes 
10. Anyway it seems that pakets with length 48 are only present when 
system doesnt work.

What do you think ?

Regards,

Gianluca




Trond Myklebust wrote:

>On Fri, 2007-11-16 at 13:11 +0100, markus reichelt wrote:
>  
>
>>* Gianluca Alberici <gianluca@abinetworks.biz> wrote:
>>
>>    
>>
>>>If i cd into it and ls it is like doing a refresh: everything works
>>>again for a certain amount of time, then, again. It reminds me an
>>>old version of CFS which used to claim: 'stale NFS file handle'.
>>>      
>>>
>>"there are no fish in my pond"
>>
>>
>># CONFIG_NFS_DIRECTIO is not set
>>
>>Ive had probs with that option set, disabling did the trick for me.
>>    
>>
>
>Huh? Why would directio have anything at all to do with readdir()?
>
>Trond
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>  
>

