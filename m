Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZKEQNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZKEQNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZKEQNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:13:06 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42850 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbZKEQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wtOPqijKGMHjOjB//S8UPt0h5R/lv3GEog0rQ71FsNg7xaarYafAaS4b7r7TTRXPcX
         gIiNKP6pNc41J3ZD2wQbY9/iE3KLlLSqDitUCBjrTbwVl1Ty3R8nrER4hYrIhOhNVzfy
         yW46o2v1N0MwI81mE5tg8QEnW40sggk5QBZLg=
MIME-Version: 1.0
Date: Thu, 5 Nov 2009 11:13:09 -0500
Message-ID: <e999a5f70911050813r63d4651g8f0fece623864a8f@mail.gmail.com>
Subject: Re: [PATCH] init/version.c: Define version_string only if
From: linux fan <linuxscratch@gmail.com>
To: daniel@danielguilak.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"[PATCH] init/version.c: Define version_string only if"
causes sysklogd to report "Cannot find map"

Latest kernel in which problem did not occur: 2.6.26.8

Expected result:
----------------

Nov  2 21:46:22 lfs syslogd 1.5.0: restart.
Nov  2 21:46:22 lfs kernel: klogd 1.5.0, log source = /proc/kmsg started.
Nov  2 21:46:22 lfs kernel: Inspecting /boot/System.map-2.6.26.8
Nov  2 21:46:22 lfs kernel: Loaded 27578 symbols from /boot/System.map-2.6.26.8.
Nov  2 21:46:22 lfs kernel: Symbols match kernel version 2.6.26.

Actual result:
--------------

Nov  2 18:27:10 lfs syslogd 1.5.0: restart.
Nov  2 18:27:10 lfs kernel: klogd 1.5.0, log source = /proc/kmsg started.
Nov  2 18:27:10 lfs kernel: Inspecting /boot/System.map-2.6.27
Nov  2 18:27:10 lfs kernel: Cannot find map file.
Nov  2 18:27:10 lfs kernel: Loaded 14585 symbols from 3 modules.

Result after reverse applying patch
http://marc.info/?l=linux-kernel&m=121606239729367&w=2
-------------------------

Nov  5 09:44:30 lfs syslogd 1.5.0: restart.
Nov  5 09:44:30 lfs kernel: klogd 1.5.0, log source = /proc/kmsg started.
Nov  5 09:44:30 lfs kernel: Inspecting
/boot/System.map-2.6.31.5-notifndefCONFIG_KALLSYMS
Nov  5 09:44:30 lfs kernel: Loaded 31895 symbols from
/boot/System.map-2.6.31.5-notifndefCONFIG_KALLSYMS.
Nov  5 09:44:30 lfs kernel: Symbols match kernel version 2.6.31.
Nov  5 09:44:30 lfs kernel: Loaded 292 symbols from 2 modules.
