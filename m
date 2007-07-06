Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbXGFJ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbXGFJ53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbXGFJ5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:57:20 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:49982 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416AbXGFJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GU6sTDSNAQ8Ppvkhy/ilQnEi8cZOEWf/M/cxIlUWtQdKEbSU8B61gxUTl8X8muNLVkKd0ReRwP60hLFJqXIUjMdPXOwHMayKLxYgUonLfJiLP730lLT7zkhmSIE1p7JMC/t5Jy/RN5rawDrQXt8HRTbLZQOqo6+3g7+uiwmoNMc=
Message-ID: <c83b914b0707060257g31cd84ex4f4afc57d0bbd865@mail.gmail.com>
Date: Fri, 6 Jul 2007 15:27:18 +0530
From: "sridhar lanka" <slanka64@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PG_locked vs PG_writeback
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I see that in 2.6 kernels, page lock (PG_locked) is cleared and
PG_writeback is set
when the page is submitted for i/o.  Refer __block_write_full_page().

However the header file says that

" During disk I/O, PG_locked is used. This bit is set before I/O and
 * reset when I/O completes. page_waitqueue(page) is a wait queue of all tasks
 * waiting for the I/O on this page to complete.
"

Is the comment correct?

Does this mean that a page can be written to (dirtied) while the same page
is being written to by the low level driver. From what i can see PG_locked is
only ensuring that 2 threads don't read the same page but does not gate writes
or flushes of the page (partially). On the other hand  PG_writeback is gating
another write if the same page is already being flushed.

appreciate help.
