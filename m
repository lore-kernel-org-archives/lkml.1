Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZJVRqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZJVRqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 13:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZJVRqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 13:46:24 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64803 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZJVRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 13:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YU0L6HfCtYL+Rd16MlRnoNUu259pOhvoBYXiGujyKrgFW8VJcmnFxOJif0R6Dza0Rq
         6yCv/b1M5/nBOB4NnVKQtv9INw0VOpUgTLvrvULhIUTtTcZW0h5yPqBPfa3TsZfO5xmd
         abHpNw0A7R4H9q5WPllFIg/1XRYQRReDS2SR0=
MIME-Version: 1.0
In-Reply-To: <5048.1256224623@turing-police.cc.vt.edu>
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
	 <5048.1256224623@turing-police.cc.vt.edu>
Date: Thu, 22 Oct 2009 23:16:27 +0530
Message-ID: <f22d86810910221046l366d3017r8b8823e4750ffea2@mail.gmail.com>
Subject: Re: Can current macro be accessed from interrupt context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> So given that the process ID is quite often totally pointless, what were you
> trying to accomplish by getting the process ID?
>

I am glad that you asked this question. Actually, what I am trying to
do may not be
even feasible in kernel space. Just spending some cycles on checking
the feasibility.

Here is what I am trying to do.

I am trying to emulate thread local storage in kernel space. Only conceptually.
In user space, multithreaded programs can avoid locking issues by keeping
per thread data structures, as per my understanding in kernel space there is
no such notion. Per cpu data structures is not quite the same thing
since locking
can be avoided only for accessing data local to that cpu, for
accessing data belonging
to other cpus, we would still need some locking mechanism.

Assume that, a multithreaded app talks to my kernel module using
/dev/node, and I need
to book keep certain data in kernel module. The data I am book keeping
can be kept in a
central data structure protected by spinlocks. A better way would be
per cpu data structure.

My idea is to keep data specific to each task which is talking to my
kernel module. Assumption
here is a certain task can be in kernel mode only on one cpu at a time
hence that task specific
data structure can be accessed without locks. All book keeping which
needs to be done in ISRs
would be just book keeping for the interrupted task, i.e. we would
populate interrupted task's
data structure. This is where current comes in picture.

-Leo.
