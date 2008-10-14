Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYJNR1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYJNR1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYJNR1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:27:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:57845 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYJNR1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:27:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=QEJLaoUNzbaJ9hrSDAN5FFIJjfvAPzNUHITA9L+MRPHymYxlA2eihN4i+lzEaTPqiw
         QM+5d8J5jV2eJO57lFaSCHJqScTA979PDXv4AfwM9ZGKRZ0gLFJGy5t9p4h14pAiuee7
         Cs2ew5sRaSuJ1Dk7ggSy7bMy+9OnX+ESGanpo=
Message-ID: <3aaafc130810141027p660efb62p92c586b1c40a5e71@mail.gmail.com>
Date: Tue, 14 Oct 2008 13:27:42 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Lindent and __user, etc.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indent doesn't understand macros and typedefs, so when running Lindent
it makes some wrong suggestions about pointers. For example, something
like "void fun(void __iomem *ptr)" comes back as "void fun(void
__iomem * ptr)" from Lindent. I emailed the maintainer, and as indent
doesn't do any parsing, the only solution is by telling it your
typedefs with -T. Obviously, telling Lindent about every typedef and
special macro in the kernel might be prohibitive, but should it at
least know about __kernel, __user, etc. and all the u8, u16, etc.
typedefs?

Letting indent know about some common typenames will also help it find
other style bugs it currently misses. I can submit more examples if
desired, and I'll submit a patch to Lindent if people think it would
be a good idea. Please CC me directly with replies.

Thanks,
J.R.
