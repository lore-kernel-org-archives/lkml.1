Return-Path: <linux-kernel-owner+w=401wt.eu-S1946391AbXBIL62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946391AbXBIL62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946394AbXBIL61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:58:27 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:1757 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946399AbXBIL60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:58:26 -0500
Date: Fri, 9 Feb 2007 12:58:21 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: David Ford <firefighterblu3@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
Message-ID: <20070209115821.GD10330@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	David Ford <firefighterblu3@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <45C6BCE5.90103@shaw.ca> <20070204213603.a5bce839.akpm@linux-foundation.org> <45C6C531.20508@shaw.ca> <20070204221741.63152cbe.akpm@linux-foundation.org> <523e55a00702081326j43de05e3hdd8cf35e946eae9@mail.gmail.com> <45CBE30D.5030006@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45CBE30D.5030006@nvidia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ayaz Abdulla wrote:
> For all those who are having issues, please try out the attached patch.

Will try.
I reverted to 2.6.19 w/o suspend/resume patch last weekend to make
sure on 2.6.19 forcedeth is stable and noticed something odd:

Because I didn't include the suspend/resume patch I obviously had to
a down/rmmod/modprobe/up cycle after each resume and I noticed that
the behaviour seems to alternate between resumes:

Behaviour 1:
  After modprobe I get two interface 'eth0' and 'eth1' for the two
  ports, as expected.

Behaviour 2:
  After modprobe I get one interface 'eth3' (which should be 'eth1')
  and one interface with increasing numbers (which should be 'eth0',
  last resume it was 'eth12' IIRC).

As I said if I get behaviour 1 on one resume I get behaviour 2 on
the next resume and vice versa.  That seems rather odd to me.

On a not quite related note, forcedeth shows a different ethtool
output (compared to e100), when no cable is connected to the port:

forcedeth, no cable connected:
|Settings for eth1:
|	Supported ports: [ MII ]
|	Supported link modes:   10baseT/Half 10baseT/Full 
|	                        100baseT/Half 100baseT/Full 
|	                        1000baseT/Full 
|	Supports auto-negotiation: Yes
|	Advertised link modes:  10baseT/Half 10baseT/Full 
|	                        100baseT/Half 100baseT/Full 
|	                        1000baseT/Full 
|	Advertised auto-negotiation: Yes
|	Speed: Unknown! (65535)
|	Duplex: Unknown! (255)
|	Port: MII
|	PHYAD: 1
|	Transceiver: external
|	Auto-negotiation: on
|	Supports Wake-on: g
|	Wake-on: d
|	Link detected: no

e100, no cable connected:
|Settings for eth0:
|        Supported ports: [ TP MII ]
|        Supported link modes:   10baseT/Half 10baseT/Full 
|                                100baseT/Half 100baseT/Full 
|        Supports auto-negotiation: Yes
|        Advertised link modes:  10baseT/Half 10baseT/Full 
|                                100baseT/Half 100baseT/Full 
|        Advertised auto-negotiation: Yes
|        Speed: 10Mb/s
|        Duplex: Half
|        Port: MII
|        PHYAD: 1
|        Transceiver: internal
|        Auto-negotiation: on
|        Supports Wake-on: g
|        Wake-on: g
|        Current message level: 0x00000007 (7)
|        Link detected: no

Note that e100 returns the lowest possible speed if no link is
detected, while forcedeth seems to return -1, which ethtool doesn't
seem to recognise as a valid response (I guess, why else would it
show the number after 'Unknown!').

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
