Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZAFU57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZAFU57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZAFU5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:57:48 -0500
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:57762 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZAFU5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:57:47 -0500
Message-ID: <4963C5C0.2080304@freemail.hu>
Date: Tue, 06 Jan 2009 21:57:36 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: confusing checkpatch.pl messages
Content-Type: multipart/mixed;
 boundary="------------040801060106060105040800"
X-DCC-mail.t-online.hu-Metrics: mail00a.mail.t-online.hu 32710; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040801060106060105040800
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit

Hi,

I run the checkpatch.pl against the attache file and it reported some
confusing warning and error messages. The attached file has an obsoleted
syntax:

>From "info gcc", Chapter 5.21 "Designated Initializers":
>  In a structure initializer, specify the name of a field to initialize
> with `.FIELDNAME =' before the element value.  For example, given the
> following structure,
>
>      struct point { int x, y; };
>
> the following initialization
>
>      struct point p = { .y = yvalue, .x = xvalue };
>
> is equivalent to
>
>      struct point p = { xvalue, yvalue };
>
>  Another syntax which has the same meaning, obsolete since GCC 2.5, is
> `FIELDNAME:', as shown here:
>
>     struct point p = { y: yvalue, x: xvalue };

However, the checkpatch.pl speaks about labels, which are incorrect, I think:
> $ /usr/src/linux/scripts/checkpatch.pl --file test.c
> WARNING: labels should not be indented
> #5: FILE: test.c:5:
> +       open: test_open,
>
> ERROR: spaces required around that ':' (ctx:VxW)
> #6: FILE: test.c:6:
> +       release: test_close,
>                ^
>
> WARNING: labels should not be indented
> #6: FILE: test.c:6:
> +       release: test_close,
>
> ERROR: spaces required around that ':' (ctx:VxW)
> #7: FILE: test.c:7:
> +       ioctl: test_ioctl,
>              ^
>
> WARNING: labels should not be indented
> #7: FILE: test.c:7:
> +       ioctl: test_ioctl,
>
> total: 2 errors, 3 warnings, 9 lines checked
>
> test.c has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.

Regards,

	Márton Németh

--------------040801060106060105040800
Content-Type: text/x-csrc;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.c"


#include <linux/blkdev.h>

static struct block_device_operations bdops = {
	open: test_open,
	release: test_close,
	ioctl: test_ioctl,
};


--------------040801060106060105040800--
