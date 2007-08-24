Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbXHXHvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbXHXHvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbXHXHvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:51:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:12165 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbXHXHvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QYHI5pyb4injMBW1h4TV987UCKHXkCdkQrhM1VNkfc07XFIOn8GyEk9zPYynxkJHPfpgQmVM5Gxi3R6WkG0faC/CQ7IlQUF/4H0E/SqO/GqlvhKQnd0PrEz5KadHoN2s/J1rbEduQ36jaC7+B5zHlyuT4qU9Y3GcRaiDkPEWRM0=
Message-ID: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com>
Date: Fri, 24 Aug 2007 03:51:36 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: apw@shadowen.org
Subject: false positive in checkpatch.pl (complex macro values)
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in some code that does like:
#define foo { a, b, c, \
    d, e, f, g }
...
int boo[] = foo;
...

checkpatch.pl throws a fit:
ERROR: Macros with complex values should be enclosed in parenthesis
#10: FILE: ...
+#define foo {a, b, c, d}

perhaps the check should also allow {...} ?  or ignore lists like this ...
-mike
