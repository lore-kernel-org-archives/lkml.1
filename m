Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbXFSR2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbXFSR2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXFSR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:28:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:23403 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbXFSR20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:28:26 -0400
Date: Tue, 19 Jun 2007 19:28:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How would I do this? (expert tricks) OT
In-Reply-To: <256797.88744.qm@web52504.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0706191919280.5731@fbirervta.pbzchgretzou.qr>
References: <256797.88744.qm@web52504.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 19 2007 10:14, Marc Perkel wrote:
>> 
>> tcpdump -lni any port 25
>> iptables -p tcp --dport 25 -j NFQUEUE
>> ...
>> 
>
>Thanks Jan, but I'm not sure it answers my question.

There's more than one way to do it.

One is...
	tcpdump -lni eth0 tcp [extra operands to match SYN packets] |
	myprogram

a longer one is to write your own netfilter userspace program
that receives the TCP SYNs (by means of -j NFQUEUE) and does
take action.

Another one is to use -j LOG and let your program parse
down /var/log/firewall. Like

	iptables -A INPUT -p tcp --dport 25 --syn -j LOG --log-prefix "[evil]"
	tail -f /var/log/firewall | grep '^\[evil\]' | myscript

myscript:
#!/usr/bin/perl

while (defined(my $line = <>)) {
	my($ip) = ($line =~ /SRC=(\S+)/);
	# Do something
}

>I want to run a script every time a connection attempt is made in real time

The scripts runs constantly, preferably.

>with the IP address as a parameter to the script. How would I do that? Suppose
>my script is:
>
>iplog <ipaddress>
>
>
>
>
>       
>____________________________________________________________________________________
>Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
>http://mobile.yahoo.com/go?refer=1GNXIC
>

	Jan
-- 
