Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZGAXnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZGAXnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZGAXnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:43:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:14500 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZGAXna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=rRECsZmLXZjVAYKiAqzXZiD7AR+51vztymNuxtMl/u6a3hAfK73sQCE8a1HfyrAirJ
         4Bw0mipE2T8sjG4GnkYIuXQUXNXUPg5crwfIiSbUaQH4M2RaPhhj+ymTyjL2scWFWEdH
         6xDuP14YHevLnWWxoKw3Mm9RHSluAMULarih8=
Message-ID: <4A4BF4A2.8030607@gmail.com>
Date: Wed, 01 Jul 2009 20:43:30 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090626)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: tools/perf compile error: ignoring return value of 'read', declared
 with attribute warn_unused_result
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    CC builtin-stat.o
cc1: warnings being treated as errors
builtin-stat.c: In function 'run_perf_stat':
builtin-stat.c:243: error: ignoring return value of 'read', declared with attribute warn_unused_result
builtin-stat.c:256: error: ignoring return value of 'read', declared with attribute warn_unused_result
make: *** [builtin-stat.o] Error 1

Apparently my version of gcc and/or glibc do not agree with -Werror.  Would the fix be as simple as:

    if *read(go_pipe[0], &buf, 1) < 0) {
            perror("Failed to read go_pipe.");
            exit(1);
    }

?

-- 
Kevin Winchester


