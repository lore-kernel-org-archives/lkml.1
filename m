Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYAXUnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYAXUnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbYAXUgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:36:03 -0500
Received: from [212.12.190.108] ([212.12.190.108]:38806 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756955AbYAXUf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:35:59 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-fsdevel@vger.kernel.org
Subject: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Thu, 24 Jan 2008 23:36:00 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200801242336.00340.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings!

data=ordered mode has proven reliable over the years, and it does this by 
ordering filedata flushes before metadata flushes.  But this sometimes 
causes contention in the order of a 10x slowdown for certain apps, either 
due to the misuse of fsync or due to inherent behaviour like db's, as well 
as inherent starvation issues exposed by the data=ordered mode.

data=writeback mode alleviates data=order mode slowdowns, but only works 
per-mount and is too dangerous to run as a default mode.

This RFC proposes to introduce a tunable which allows to disable fsync and 
changes ordered into writeback writeout on a per-process basis like this:

      echo 1 > /proc/`pidof process`/softsync


Your comments are much welcome!


Thanks!

--
Al

