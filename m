Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbXA3Vad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbXA3Vad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXA3Vad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:30:33 -0500
Received: from mail.zeugmasystems.com ([192.139.122.66]:46838 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519AbXA3Vac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:30:32 -0500
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 16:30:32 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Date: Tue, 30 Jan 2007 13:16:22 -0800
Message-ID: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Thread-Index: AcdEU5fz6KG1BYrCSi+g+HVeA9AbYwAW2p/g
From: "Kaz Kylheku" <kaz@zeugmasystems.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Chris Friesen" <cfriesen@nortel.com>
Cc: <linux-kernel@vger.kernel.org>, <libc-hacker@sources.redhat.com>,
       <libc-alpha@sources.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> I described in details why and how M:N model better, and its drawbacks
> include all issues mentioned by Ulrich Drepper, but nevertheless its
> advantages are far too superiour than those which can be
> provided by 1:1
> model.

M:N threading is an unnecessary performance hack that's needed by people
who are living in a C or C++ exile away from some language that has
lexical closures, generators or first-class continuations. Not having
these niceties, they resort to emulating them with threads. The proper
thing to do is to rewrite the code to use state machines which can be
driven by any available thread. Or else, write yourself a
source-to-source transformer that will give C the lexical closure,
generator, or continuation features that you need to express the
solution that way.

There is no need to retain any vestiges of a user space threading
implementation when you have the real thing.

Programs which appear to benefit from that model are badly optimized or
badly designed. A smartly written program uses an available thread to do
as much work as possible, until that thread happens to block or its time
slice burns up.
