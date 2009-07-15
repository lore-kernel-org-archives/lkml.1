Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZGOSwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZGOSwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbZGOSwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:52:41 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:26026 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755747AbZGOSwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:52:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: FW: avoiding run_workqueue() recursion
Date: Wed, 15 Jul 2009 11:52:39 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501CFAFCD@exchange.ZeugmaSystems.local>
In-Reply-To: <20090715183941.GA13341@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: FW: avoiding run_workqueue() recursion
Thread-Index: AcoFfDHpyBtWsCzcSpe+ovCIzLEmVAAAI2sg
References: <DDFD17CC94A9BD49A82147DDF7D545C501CFAE3D@exchange.ZeugmaSystems.local> <20090715183941.GA13341@redhat.com>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg:

>If we just return silently, we do not flush but hide the problem ?
>And in this can lead to other problems which are very hard to
>trigger/debug.

True. I think flushing is an invalid operation for a thread that is
already walking the work-queue, like keventd. It is inherently bug in
the code somewhere else (may be in a work function?). I liked your idea
of replacing WARN_ON() with BUG_ON() but I do understand that a panic
could be a bigger hammer here. May be we can have some sort of
restrictions or conventions for writing work functions?  I don't know. 

Ani

