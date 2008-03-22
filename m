Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYCVUZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYCVUZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 16:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYCVUY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 16:24:58 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:40776 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751687AbYCVUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 16:24:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=wfCNgUKoSgn8xfKZVo+m952oIE6Py7xm25jIPEHtt1qyfGVXcslCqNLuTwt/Zq6aVR0W96xr73S0PvLsVjYX4N2KCsJ6Lh0XcswAGwAHonZrl6eUbkQzztI9YiJ8QefVKnunRFRWtUYzNc9meJJ4Sk8LzZABW5KbrhspBCn1QZA=  ;
X-YMail-OSG: OJHzZ3wVM1mW3ltXiOWEzuhaIjMWK1MOtCIQERsRYg4NKv9ZuaiX.oF3CkDiDgDj0hrPrvm_5w--
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 22 Mar 2008 13:24:54 -0700
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25 regression: powertop says 120K wakeups/sec
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed this with 2.6.25-rc2 (if not before), and the problem
is still there with 2.6.25-rc6-git (as of this AM).

System is an Athlon64 single CPU laptop, and instead of reading a
few dozen wakeups per second, it says a many tens of thousands...
clearly wrong.  In previous kernels it gave more plausible counts;
unfortunately high because of various un-evolved desktop tools in
this Ubuntu system (Feisty).

Possibly more truthful, it says that the system never enters
C1 or C2, and spends all its time in C0.  Though if I look at
/sys/devices/system/cpu/cpu0/cpuidle/state[01]/usage, that
seems to tell a different story ... it's C0 that's never used.
In previous kernels it reported time in both C0 and C2.  ISTR
some patch to avoid C2, which would explain part of this.

Comments or fixes, anyone?

- Dave

