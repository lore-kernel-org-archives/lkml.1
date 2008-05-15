Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbYEOTVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbYEOTVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYEOTVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:21:17 -0400
Received: from rocgw.pt.com ([74.39.135.225]:33375 "EHLO rocgw.pt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbYEOTVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:21:16 -0400
To: linux-kernel@vger.kernel.org
Subject: TAHI IPv6 testing of kernel 2.6.20
MIME-Version: 1.0
X-KeepSent: AB0C1694:0B207957-8525744A:006A249F;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OFAB0C1694.0B207957-ON8525744A.006A249F-8525744A.006A50C8@pt.com>
From: William Seppeler <wrs@pt.com>
Date: Thu, 15 May 2008 15:21:14 -0400
X-MIMETrack: Serialize by Router on notes1/PTI(Release 8.0.1HF85 | April 1, 2008) at 05/15/2008
 03:21:14 PM,
	Serialize complete at 05/15/2008 03:21:14 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed on the TAHI website that kernel.org had the 2.6.20 kernel 
certified for IPv6 Ready Logo Phase2 as a router device. 

The application was submitted on 20070827 (Application ID: 
US-2-C-20070827-000142) and certified on 20070926. 

I'm currently testing a 2.6.20 kernel using Self_Test_1.4.14 (performing 
Phase2 host testing - ipv6ready_p2_host).  It passes all tests except for 
one.  I'm failing test: 

    v6LC_2_3_6_G - Redirected to Alternate Router: Invalid (Target Address 
is Multicast) 

Based on the kernel.org application date, I assume the application was 
submitted using TAHI Self_Test_1.4.8.  I see from the Self_Test CHANGELOG 
that test v6LC_2_3_6_G was modified after the application date: 

    2007/09/26    Yukiyo Akisada
       nd.p2/v6LC_2_3_6_G.def - correct packet definition 


Q: Has the kernel.org group retested the 2.6.20 kernel using any of the 
recent Self_Test releases?  In particular, Self_Test_1.4.14 or greater? 
And were there any failures? 

As for details into the v6LC_2_3_6_G test failure: 

The log shows the test fails due to processing an invalid redirect packet 
(ie: it's a negative test).  The redirect packet contains a multicast 
address as a target address.  RFC2461 (p.26) doesn't explicitly state this 
is invalid: 

      Target Address 
                     An IP address that is a better first hop to use for
                    the ICMP Destination Address.  When the target is
                    the actual endpoint of communication, i.e., the
                    destination is a neighbor, the Target Address field
                    MUST contain the same value as the ICMP Destination
                    Address field.  Otherwise the target is a better
                    first-hop router and the Target Address MUST be the
                    router's link-local address so that hosts can
                    uniquely identify routers.

But the test does appear to make sense based on the last sentence.  The 
linux kernel I'm testing shows an echo response trying to use the 
multicast address from the redirect packet as it's first hop.  This is 
what causes the test to fail.  The expectation is that the linux kernel 
would ignore the redirect packet entirely. 

As stated, this is the ONLY test in the whole Phase2 test suite that 
fails.  I understand the failure, but I don't understand how the 2.6.20 
kernel is Phase2 certified.  At least not with the current Self_Test test 
suite. 

Q: Has anyone else had issues in getting the 2.6.20 kernel to pass all 
TAHI IPv6 Ready Logo Phase2 tests? 

Please CC answers to wrs@pt.com

Thank You, 

========================================
William Seppeler
Test Engineer
Performance Technologies Inc.
205 Indigo Creek Dr.
Rochester, NY  14626

Phone:  (585) 256-0200, Fax:  (585) 256-0791
Email:  wrs@pt.com, Web:  www.pt.com
========================================

