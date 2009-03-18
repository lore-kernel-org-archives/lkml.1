Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbZCRDGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbZCRDGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbZCRDGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:06:13 -0400
Received: from n11a.bullet.mail.mud.yahoo.com ([209.191.125.176]:38668 "HELO
	n11a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754909AbZCRDGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:06:09 -0400
X-Yahoo-Newman-Id: 435672.92534.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1jWWBUPGqW7vAWkrJb5yKqi2hm6m62u1j28wJP3nXODTHVv8SdvUn/gOwLJDr4ZdZeFQG0CMZTVevQEPgES6yv8WiRbmmUxwJmbFyG064QjByIA2NhEIxHByuu399URLAHmEHDIAzU9+Ila3OGvE3CW3DbhIZwuFEmhW4GYwkj4=  ;
X-YMail-OSG: 4Xy6GggVM1lSlooFqub9.hag9jsSmWiatY_L8wDLuMU01.XUW5B0gmPAk5eKanaJPYLCXbA0gsTJZMd5yogTwMMdiSDg.G5cGN9Bybb_0l6M7_DyiSOWAutKcrqdHXpdssRuXBW2LcKxl6gvVy67gcK6
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: [patch/rfc 0/2] handle_threaded_irq()
Date: Tue, 17 Mar 2009 19:14:53 -0700
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, me@felipebalbi.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu>
In-Reply-To: <20090303004427.GA8638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171914.53688.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a followup to help address one of the omissions in the
threaded IRQ patches (v2) posted recently.  To recap, those
provided a quickcheck() routine that could wake an irq thread,
and a way to register a handler using that mechanism.

This addresses an orthogonal problem:  given some thread
demultiplexing the subsidiary IRQs reported to some top-level
interrupt, how can that kick in flow handlers chaining to
the subsidiary IRQs' handlers?

The answer here is more or less as suggested by Thomas:
using handle_threaded_irq(), a flow handler which doesn't
use handle_IRQ_event() since that doesn't much like being
called from thread context, at least when lockdep is active.

These two patches:

 - add handle_threaded_irq() flow handler;
 - kick it in for some twl4030 code

Tested on 2.6.29-rc8 code, both with and without the v2
irqthread patches.


