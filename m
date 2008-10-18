Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbYJRRKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbYJRRKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYJRRJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:09:59 -0400
Received: from web50611.mail.re2.yahoo.com ([206.190.38.157]:41863 "HELO
	web50611.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750892AbYJRRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:09:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=iYd0q3H68PVrvYualLpyC5uYwpdrmdRkInh5IAPkS6gCxv0Jqk82wvo+XcqIjBA9YW1RqQNW0TACFlmkgQ4ihjOJpnI95ZMEFQpswaZGg897C2JANpU2AO7ZXT78wO6KA5tx4jBPW/NsjW6ip3piGnEQU5SnGBHKZSbdmwDIm/w=;
X-YMail-OSG: Oiq3xIYVM1lkNxK4NUkeMyfO2_LqcauQQ2a7hpIPVBE04IYSI1twvzJYqYKxplSZnECINL.V5G6L9nrQBK53PiudNcmL_NwXavuYYkgHNK1V1zVV.ew5kLpukyS5LmgoI9_R6hhQmZhM.2wwG8A0A3eDePslqsgk_wBL3nmdN1dS6HoELWCsyS2B7I4-
X-Mailer: YahooMailWebService/0.7.247.3
Date: Sat, 18 Oct 2008 10:09:57 -0700 (PDT)
From: marty <martyleisner@yahoo.com>
Subject: monitoring bytes processed off network interface in user space
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <452027.60082.qm@web50611.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to be able to see if user space is processing network traffic
(as opposed to raw rx/tx packets on the interface).  

Is there a way to track this?  (beyond modifying all the applications which
deal with the network).  I need to track traffic to/from userspace to a 
"specific" interface, not things like localhost.

Note, this is an embedded system talking  (at times) appletalk,novell, ipv4, ipv6 and maybe other things...

Currently we have something like

while(1) {
     WOL packet
     timeout on no activity on rx/tx counts and then go sleep
}

Unfortunatley, rx/tx activity won't solve the problem on a busy lan with lots of broadcast packets.   If our WOL filter will only wake us on (lets say) on directed TCP/UDP packets, a constant ping will prevent us from going back to sleep...

If there isn't a way to do this, it may be simple to add some counters
in the right places in the network stacks (instead of packets, it would be bytes).

marty

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
