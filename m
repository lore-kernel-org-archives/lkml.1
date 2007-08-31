Return-Path: <linux-kernel-owner+w=401wt.eu-S965277AbXHaMNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbXHaMNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 08:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964941AbXHaMN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 08:13:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:39715 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964936AbXHaMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 08:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oKll52GUtBZdZwEYvKB8lcd8Py/OO4wE6z8Sh3VpT1o+JsWriqZbcDRK3+7cGTzNWIHuDJimMcXaFwX6osf/1J6Jh6f4ldI/npM1I2x+w1vAGqehKbLViAkuUe8RBTVmoGRbDqJ/I0/nIAkKiBdXDRAZZXNYL/HXeTABakmueoY=
Message-ID: <379fb4870708310513o46a721c6l3080179ccbb8f519@mail.gmail.com>
Date: Fri, 31 Aug 2007 14:13:26 +0200
From: "anon... anon.al" <anon.asdf@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Nonblocking call may block in a mutex? Nonblocking call after poll may fail?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This is a driver-related question on non-blocking writes and poll.

Setup:
there is a single output-buffer (in kernel-space) of 24 bytes for
writes from all processes A, B, and C: each process is restricted to
use at most 8 bytes: 8*3 = 24
(until that data is handled (interrupt-handler...))

Question:
If this output-buffer has "4-bytes space remaining for process A",
then a non-blocking write of process A could still encounter a locked
mutex, if process B is busy writing to the output-buffer.

Should process A now block/sleep until that mutex is free and it can
access the output-buffer (and it's 4 bytes space)?

What about a non-blocking (write-) poll of process A: if the poll call
succeeds (the output buffer has space remaining for process A), and
process A now performs a non-blocking write: what happens if A
encounters a blocked mutex, since process B is busy writing to the
output-buffer.
a) Should A block until the mutex is available?
b) Should A return -EAGAIN, even though the poll call succeeded?
c) Should it be impossible for this to happen! i.e. -> should process
A already "have" the mutex in question, when the poll call succeeds
(thus preventing B from writing to the output buffer)

For c) What if process A "has" the mutex, but never does the
non-blocking write. Then no process can write, since the mutex is held
by process A...


I'll appreciate any answer, or pointer to relevant information.

Thanks Albert
