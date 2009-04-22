Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZDVXTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZDVXTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 19:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZDVXTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 19:19:23 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:41855 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDVXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 19:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DGSrXCatyUr1A/6+Fb0SwyaFGsBdkkJwbkPsAayxmv6gUUpE8m5XScHy6hebvfr+ej
         EWqwpyh2nMC/QGEP1kWIS87BAVV2hxH5PnRpMQ/mSrj+RDCFlXF8RXI13gjtoYjXPDRD
         8rWALt60c8VDGWZIoFwv3FfcBIQxtUDi+t6JE=
MIME-Version: 1.0
Date: Thu, 23 Apr 2009 09:19:21 +1000
Message-ID: <21d7e9970904221619v7d7990bfq697cfca64a7ed6d2@mail.gmail.com>
Subject: i2c algo bit timeout question
From: Dave Airlie <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to any i2c people,

So I've been debugging some EDID fetching failures and wanted to ask
about the use of time_after_eq in the i2c bit banging code.

EDID specification recommends 2ms timeout for the ack on the initial
read, so we set the timeout in our code to usecs_to_jiffies(2200) (10%
margin of error). On my systems this ends up as 1, and we seem to fail
to retrieve EDID one in 10-20 times. Changing the value to 2, always
gets me the EDID I want.

So looking at drivers/i2c/algos/i2c-algo-bit.c it appears it uses
time_after_eq on jiffies, start + timeout value. So if we have a 10ms
jiffie resolution and enter this at the 9ms point in the 10ms window,
we will seem to exit the loop after 1ms instead of the minimum which I
asked for which is 2.2ms. Should this code use time_after instead of
time_after_eq?

or am I missing something else.
Dave.
