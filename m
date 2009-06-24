Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbZFXQQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbZFXQQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760560AbZFXQQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:16:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:20845 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZFXQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=K6HloMXjRW8EciKZxtYCH8uVHRb5a1CKhi0NcjBL9GpnI2n9y/ZRNZkeWKxx/vuIRx
         YpOhpCjwbF3EUMxZugiGgWXYrrsGY1UpbvsC10NQhU4lXbj2/e3exVRPl62WTg5I1AX8
         OsqND+l8iCM+GEqrQcD6MbsJDoU3a1dN1Nwm4=
MIME-Version: 1.0
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 24 Jun 2009 12:16:18 -0400
Message-ID: <3e8340490906240916v8017770w279e7ecfab079894@mail.gmail.com>
Subject: PI futexes - allocations required?
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I was reading the futex.c code, I noticed that locking a PI mutex
can apparently cause an allocation, via alloc_pi_state() and
refill_pi_state_cache(). Doesn't this mean that memory allocation (and
the corresponding possible IO latency) could be introduced into
real-time code - the primary user of PI mutexes?

Am I missing something here, or is some sort of PI mutex "prefaulting"
needed to avoid allocation when taking PI locks? It would seem that
the sleeps and unbounded latency that a GFP_KERNEL allocation can
introduce would make these unusable for real-time code...
