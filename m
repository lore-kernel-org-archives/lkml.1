Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbXFSTgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbXFSTgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761373AbXFSTgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:36:03 -0400
Received: from web52508.mail.re2.yahoo.com ([206.190.48.191]:49080 "HELO
	web52508.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761211AbXFSTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:36:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=AppwvwagzqnR2KRFOvNpyC0Sr4gqStZXeT66ZtSZ0oyCjp5QYvEg5RAmuPZeKWFxE33cwYMri7sp5xrTAARDK+/di13W+sBTfh5K+615fEVJJXBEIrl1ujxFe1VUv3LSsS4nKOR4NO/ATJLyXLiXtzJ3odupEw1RHhcPtkGPwJ8=;
X-YMail-OSG: 8y5wey8VM1n05AqLjW0sLjPMGAz5bTnW3Y6XhqSZIDFOQKSnW8r2oCHeYS2zija4C4PjQFffp.GaEq7w623jZ4aWO2kzbGIUs9zI7Hoj_D89ndKQXaQAq8f1TaRSh5aG
Date: Tue, 19 Jun 2007 12:36:00 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: How would I do this? (expert tricks) OT
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706191919280.5731@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <684309.25266.qm@web52508.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Jun 19 2007 10:14, Marc Perkel wrote:
> >> 
> >> tcpdump -lni any port 25
> >> iptables -p tcp --dport 25 -j NFQUEUE
> >> ...
> >> 
> >
> >Thanks Jan, but I'm not sure it answers my
> question.
> 
> There's more than one way to do it.
> 
> One is...
> 	tcpdump -lni eth0 tcp [extra operands to match SYN
> packets] |
> 	myprogram
> 
> a longer one is to write your own netfilter
> userspace program
> that receives the TCP SYNs (by means of -j NFQUEUE)
> and does
> take action.
> 
> Another one is to use -j LOG and let your program
> parse
> down /var/log/firewall. Like
> 
> 	iptables -A INPUT -p tcp --dport 25 --syn -j LOG
> --log-prefix "[evil]"
> 	tail -f /var/log/firewall | grep '^\[evil\]' |
> myscript
> 
> myscript:
> #!/usr/bin/perl
> 
> while (defined(my $line = <>)) {
> 	my($ip) = ($line =~ /SRC=(\S+)/);
> 	# Do something
> }
> 
> >I want to run a script every time a connection
> attempt is made in real time
> 
> The scripts runs constantly, preferably.
> 
> >with the IP address as a parameter to the script.
> How would I do that? Suppose
> >my script is:
> >
> >iplog <ipaddress>
> >
> >
> >
> >
> >       
>
>____________________________________________________________________________________
> >Take the Internet to Go: Yahoo!Go puts the Internet
> in your pocket: mail, news, photos & more. 
> >http://mobile.yahoo.com/go?refer=1GNXIC
> >

Thanks Jan,

I think what you sent me is workable. I noticed it
goes to the file /var/log/messages. Is there a way to
make it go to a specific file? Thanks a lot for your
help. I've been experimenting with some new and very
interesting ways to catch spam and this could be yet
another breakthrough.






      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 


