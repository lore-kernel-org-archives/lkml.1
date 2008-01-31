Return-Path: <linux-kernel-owner+w=401wt.eu-S1765048AbYAaD0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765048AbYAaD0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYAaD03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:26:29 -0500
Received: from stinky.trash.net ([213.144.137.162]:36159 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYAaD01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:26:27 -0500
Message-ID: <47A13FBD.8050803@trash.net>
Date: Thu, 31 Jan 2008 04:25:49 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Krzysztof Piotr Oledzki <ole@ans.pl>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: cups slow on linux-2.6.24
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>	 <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>	 <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>	 <47A07FEA.3000702@trash.net>	 <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>	 <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>	 <47A13573.7090804@trash.net> <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
In-Reply-To: <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Jan 31, 2008 10:41 AM, Patrick McHardy <kaber@trash.net> wrote:
>
>   
>> Thanks. In the dump we can see that connections reusing ports
>> always have their first SYN dropped and retransmissted three
>> seconds later. I'm not sure whats causing this yet, do you have
>> any firewall rules that affect loopback traffic?
>>     
>
> No firewall.
>
> And the "lp" is just to print to a file@localhost.
>
> # lpadmin -p lp -i /etc/cups/interfaces/lp -v lpd://localhost/file -o
> printer-error-policy=retry-job
> # lpadmin -p file -i /etc/cups/interfaces/file -v file:/dev/null -o
> printer-error-policy=retry-job
>
> Filter for lp is ..
>   cat $6
>
> Filter for file is ...
>   cat $6 >/tmp/$$
>   

Actually its probably the SYN/ACK that is dropped. Please try whether

modprobe ipt_LOG
echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid

and then running the test again logs something to the ring buffer.
You don't need to run the entire test, just until you get a log
message from conntrack.


