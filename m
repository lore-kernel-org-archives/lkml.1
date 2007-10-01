Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbXJAVhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbXJAVhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXJAVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:36:56 -0400
Received: from briare1.fullpliant.org ([81.56.244.40]:37587 "HELO
	briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752657AbXJAVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:36:55 -0400
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2007 17:36:55 EDT
From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Date: Mon, 01 Oct 2007 22:27:52 GMT
Message-ID: <07E3AEH11@briare1.fullpliant.org>
X-Mailer: Pliant 96
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> Really, i have never seen a _single_ mainstream app where the use of
> sched_yield() was the right choice.

Pliant 'FastSem' semaphore implementation (as oppsed to 'Sem') uses 'yield'
http://old.fullpliant.org/

Basically, if the ressource you are protecting with the semaphore will be held
for a significant time, then a full semaphore might be better, but if the
ressource will be held just a fiew cycles, then light aquiering might bring best
result because the most significant cost is in aquiering/releasing.

So the aquiering algorithm for fast semaphores might be:
try to aquire with a hardware atomic read and set instruction, then if it fails,
call yield then retry (at least on a single processor single core system).


